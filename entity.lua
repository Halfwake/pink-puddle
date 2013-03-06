require 'util'
require 'const'

Entity.batches = {
			YellowShoot = love.graphics.newSpriteBatch(IMAGE.yellow_shoot, MAX_BULLETS, "stream"),
			IceBall = love.graphics.newSpriteBatch(IMAGE.ice_ball, MAX_BULLETS, "stream"),
		 }

function Entity.add(newEntity)
	table.insert(Entity.newEntity, newEntity)
end

function Entity.newConstructor(supers, constructorArguments, mixins, updateMixins, image)
	local newConstructor = {}
	local newConstructorTemplate = {}
	for mixinIndex, mixinin in pairs(mixins) do
		for memberIndex, member in pairs(mixins) do
			newConstructorTemplate[memberIndex] = member
		end
	end
	return function newConstructor(...)
		local newObject = {}
		newObject = table.shallow_copy(newConstructorTemplate)
		for index, super in supers do
			newObject = table.join(newObject, super)
		end
		for i = 1,(#constructorArguments) do
			newObject[constructorArguments[i]] = arg[i]
		end
		newObject.image = image
		newObject.update = function(self, dt)
			for _, item in updateMixins do
				self:(dt)
			end
		end
		Entity.add(newObject)
		return newObject
	end
end




function Entity.moveAuto(self, dt)
	self.x = self.x + self.dx * dt * self.speed
	self.y = self.y + self.dy * dt * self.speed
end

function Entity.addBatch(self)
	local image = self.batchPointer:getImage()
	self.batchPointer:add(math.round(self.x - image:getWidth() / 2), math.round(self.y - image:getHeight() / 2), self.orientation)
end

function Entity.inBounds(self)
	if self.x < 0 or self.x > love.graphics.getWidth() or self.y < 0 or self.y > love.graphics.getHeight() then
		return false
	end
	return true
end

function Entity.setDelta(dx, dy)
	self.dx = dx
	self.dy = dy
end

function Entity.isEnemy(self, target)
	if not self.friendly and target.type == 'player' then
		return true
	elseif self.friendly and target.type == 'monster' then
		return true
	end
	return false
end

function Entity.isTouching(self, target)
	local distance_squared
	local radius_squared
	if target.type == 'player' then
		distance_squared = math.pow(self.y - target.y, 2) +  math.pow(self.x - target.x, 2)
		radius_squared = math.pow(target.image:getWidth() / 3, 2)
	elseif target.type == 'monster' then
		distance_squared = math.pow(self.y - (target.y - self.batchPointer:getImage():getHeight() / 2), 2) +  math.pow(self.x - (target.x - self.batchPointer:getImage():getWidth() / 2), 2)
		radius_squared = math.pow(target.batchPointer:getImage():getWidth() / 2, 2)
	end
	if radius_squared >= distance_squared then
		return true
	end
	return false
end
