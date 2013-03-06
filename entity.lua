require 'util'
require 'const'

Entity.batches = {
			YellowShoot = love.graphics.newSpriteBatch(IMAGE.yellow_shoot, MAX_BULLETS, "stream"),
			IceBall = love.graphics.newSpriteBatch(IMAGE.ice_ball, MAX_BULLETS, "stream"),
			YellowBouncer = love.graphics.newSpriteBatch(IMAGE.yellow_bouncer, MAX_MONSTERS, 'stream'),
			GreenChaser = love.graphics.newSpriteBatch(IMAGE.green_chaser, MAX_MONSTERS, 'stream'),
			OctoShot = love.graphics.newSpriteBatch(IMAGE.octo_shooter, MAX_MONSTERS, 'stream'),
			DemonPig = love.graphics.newSpriteBatch(IMAGE.demon_pig, MAX_MONSTERS, 'stream'),

		 }
Entity.entities = {}

function Entity.add(newEntity)
	table.insert(Entity.entities, newEntity)
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


function Entity.isAlive(self)
	return self.health > 0
end

function Entity.loseHealth(self, damage)
	self.health = self.health - damage
	if not Entity.isAlive(self) then
		Entity.entities[table.index(Entity.entities, self)] = nil
	end
end

function Entity.moveAuto(self, dt)
	Entity.move(self, dt, dx, dy)
end

function Entity.move(self, dt, dx, dy)
	self.x = self.x + dx * dt * self.speed
	self.y = self.y + dy * dt * self.speed
end

function Entity.takeHit(self, hitter)
	self.health = self.health - hitter.damage
end

function Entity.updateFireDelta(self, dt)
	self.fireDelta = self.fireDelta - dt
	if self.fireDelta <= 0 then
		self:fire()
		self.fireDelta = self.fireDelay
	end
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

function Entity.setDelta(self, dx, dy)
	self.dx = dx
	self.dy = dy
end

function Entity.isEnemy(self, target)
	if self.friendly == target.friendly  then
		return true
	end
	return false
end

function Entity.isTouching(self, target)
	local distance_squared = math.pow(self.y - target.y, 2) +  math.pow(self.x - target.x, 2)
	local radius_squared = math.pow(target.image:getWidth() / 3, 2)
	if radius_squared >= distance_squared then
		return true
	end
	return false
end

function Entity.getSlope(self, target)
	return (self.y - self.target.y) / (self.x - self.target.x)
end

function Entity.distance(self, target)
	return math.sqrt(math.pow(self.y - target.y, 2) + math.pow(self.x - target.x, 2))
end

function Entity.shootSpray(self)
	local orientation = 0
	Entity.add(self.bulletType.new(self.x, self.y, 0.5, 0.5, orientation, false))
	Entity.add(self.bulletType.new(self.x, self.y, 0.5, -0.5, orientation, false))
	Entity.add(self.bulletType.new(self.x, self.y, -0.5, 0.5, orientation, false))
	Entity.add(self.bulletType.new(self.x, self.y, -0.5, -0.5, orientation, false))
	Entity.add(self.bulletType.new(self.x, self.y, 1, 1, orientation, false))
	Entity.add(self.bulletType.new(self.x, self.y, 1, -1, orientation, false))
	Entity.add(self.bulletType.new(self.x, self.y, -1, 1, orientation, false))
	Entity.add(self.bulletType.new(self.x, self.y, -1, -1, orientation, false))
end

function Entity.follow(self, dt)
	local distance = Entity.distance(target)
	local dx, dy
	if (self.x - self.target.x) ~= 0 then
		dx = (self.x - self.target.x) / -distance
	else
		dx = 0
	end
	if (self.y - self.target.y) ~= 0 then
		dy = (self.y - self.target.y) / -distance
	else
		dy = 0
	end
	Entity.autoMove(dt)
end

function monsterTemplate:shootStraight()
	local slope = Entity.getSlope(self.target)
	local distance = Entity.getDistance(self.target) 
	local orientation = 0--math.atan(self.y - self.target.y, self.x - self.target.x) --fix this later
	local dx
	local dy
	if distance == 0 then
		dy = nil
	else
		dy = (self.target.y - self.y) / distance
	end
	if distance == 0 then
		dx = nil
	else
		dx = (self.target.x - self.x) / distance
	end
	--in case the distance on either axis is zero
	if not dx and not dy then
		dx = 0.5
		dy =0.5
	elseif not dx then
		dx = 1 - dy
	elseif not dy then
		dy = 1 - dx
	end
	Entity.add(self.bulletType.new(self.x, self.y, dx, dy, orientation, false))
end

function Entity.shootBeam(self)
	local slope = Entity.getSlope(self.target)
	local distance = Entity.distance(self.target)
	local orientation = 0--math.atan(self.y - self.target.y, self.x - self.target.x) --fix this later
	local dx
	local dy
	if distance == 0 then
		dy = nil
	else
		dy = (self.target.y - self.y) / distance
	end
	if distance == 0 then
		dx = nil
	else
		dx = (self.target.x - self.x) / distance
	end
	--in case the distance on either axis is zero
	if not dx and not dy then
		dx = 0.5
		dy =0.5
	elseif not dx then
		dx = 1 - dy
	elseif not dy then
		dy = 1 - dx
	end
	Entity.add(self.bulletType.new(self.x, self.y, dx, dy, orientation, false))
	Entity.add(self.bulletType.new(self.x, self.y, dx - 0.10, dy + 0.10, orientation, false))
	Entity.add(self.bulletType.new(self.x, self.y, dx + 0.10, dy - 0.10, orientation, false))
end

