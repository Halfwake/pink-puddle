require 'util'
require 'const'
require 'particle'

Entity = {}

Entity.batches = {
			YellowShoot = love.graphics.newSpriteBatch(IMAGE.yellow_shoot, MAX_MONSTERS + MAX_BULLETS, "stream"),
			IceBall = love.graphics.newSpriteBatch(IMAGE.ice_ball, MAX_MONSTERS + MAX_BULLETS, "stream"),
			YellowBouncer = love.graphics.newSpriteBatch(IMAGE.yellow_bouncer, MAX_MONSTERS + MAX_BULLETS, 'stream'),
			GreenChaser = love.graphics.newSpriteBatch(IMAGE.green_chaser, MAX_MONSTERS + MAX_BULLETS, 'stream'),
			OctoShot = love.graphics.newSpriteBatch(IMAGE.octo_shooter, MAX_MONSTERS + MAX_BULLETS, 'stream'),
			BatBouncer = love.graphics.newSpriteBatch(IMAGE.bat_bouncer, MAX_MONSTERS + MAX_BULLETS, 'stream'),
			DemonPig = love.graphics.newSpriteBatch(IMAGE.demon_pig, MAX_MONSTERS + MAX_BULLETS, 'stream'),
			Coobey = love.graphics.newSpriteBatch(IMAGE.coobey, MAX_MONSTERS + MAX_BULLETS, 'stream'),
			PurpleBouncer = love.graphics.newSpriteBatch(IMAGE.purple_bouncer, MAX_MONSTERS + MAX_BULLETS, 'stream'),
			Grizz = love.graphics.newSpriteBatch(IMAGE.anger_bear, MAX_MONSTERS + MAX_BULLETS, 'stream'),
		 }
Entity.entities = {}
Entity.Constructors = {}
Entity.bulletCount = 0
Entity.monsterCount = 0

function Entity.add(entity)
	if entity.type == 'monster' then
		Entity.monsterCount = Entity.monsterCount + 1
	elseif entity.type == 'bullet' then
		Entity.bulletCount = Entity.bulletCount + 1
	end
	print(Entity.monsterCount, Entity.bulletCount)
	table.insert(Entity.entities, entity)
end

function Entity.remove(entity)
	if entity.type == 'monster' then
		Entity.monsterCount = Entity.monsterCount - 1
	elseif entity.type == 'bullet' then
		Entity.bulletCount = Entity.bulletCount - 1
	end
	Entity.entities[table.index(Entity.entities, entity)] = nil
end

function Entity.draw()
	for _, entity in pairs(Entity.entities) do Entity.addBatch(entity) end
	for _,batch in pairs(Entity.batches) do
		love.graphics.draw(batch)
		batch:clear()
	end
end

function Entity.isTouching(self, target)
	local distance = Entity.distance(self, target)
	local self_width
	if self.image then
		self_width = self.image:getWidth()
	else
		self_width = self.batchPointer:getImage():getWidth()
	end
	local target_width
	if target.image then
		target_width = target.image:getWidth()
	else
		target_width = target.batchPointer:getImage():getWidth()
	end
	local width
	if self_width > target_width then width = self_width else width = target_width end
	local radius = width / 2
	if radius >= distance then
		return true
	end
	return false
end

function Entity.newConstructor(supers, constructorArguments, mixins, updateMixins, batchPointer)
	local newConstructor = {}
	local newConstructorTemplate = {}
	for mixinIndex, mixin in pairs(mixins) do
		for memberIndex, member in pairs(mixin) do
			newConstructorTemplate[memberIndex] = member
		end
	end
	return function(...)
		local newObject = {}
		newObject = table.shallow_copy(newConstructorTemplate)
		for index, super in pairs(supers) do
			newObject = table.join(newObject, Entity.Constructors[super])
		end
		for index,arg_name in pairs(constructorArguments) do
			newObject[arg_name] = arg[index]
		end
		newObject.image = image
		newObject.update = function(self, dt)
			for _, mixin in pairs(updateMixins) do
				for _, method in pairs(mixin) do
					method(newObject, dt)
				end
			end
			Entity.collisionCheck(newObject, dt)
		end
		newObject.batchPointer = batchPointer
		Entity.add(newObject)
		return newObject
	end
end


function Entity.isAlive(self)
	return (self.health > 0) or self.invuln
end

function Entity.bounce(self, dt)
	if self.x < 0 or self.x > love.graphics.getWidth() - self.batchPointer:getImage():getHeight() / 2 then
		if self.x < 0 then self.x = 0 else self.x = love.graphics.getWidth() - self.batchPointer:getImage():getHeight() / 2 end
		self.dx = -self.dx
	end
	if self.y < 0 or self.y > love.graphics.getHeight() - self.batchPointer:getImage():getWidth() / 2 then
		if self.y < 0 then self.y = 0 else self.y = love.graphics.getHeight() - self.batchPointer:getImage():getWidth() / 2 end
		self.dy = -self.dy
	end
end


function Entity.loseHealth(self, damage)
	self.health = self.health - damage
	if not Entity.isAlive(self) then
		Entity.remove(self)	
	end
end

function Entity.moveAuto(self, dt)
	Entity.move(self, dt, self.dx, self.dy)
end

function Entity.move(self, dt, dx, dy)
	self.x = self.x + dx * dt * self.speed
	self.y = self.y + dy * dt * self.speed
end

function Entity.loseHealth(self, damage)
	self.health = self.health - damage
end

function Entity.takeHit(self, hitter)
	Entity.loseHealth(self, hitter.damage)
end

function Entity.updateFireDelta(self, dt)
	if not self.fireDelta then self.fireDelta = 0 end
	self.fireDelta = self.fireDelta - dt
	if self.fireDelta <= 0 then
		if Entity.bulletCount < MAX_BULLETS then
			self:fire()
			self.fireDelta = self.fireDelay
		end
	end
end

function Entity.collisionCheck(self, dt)
	for _, entity in pairs(Entity.entities) do
		if entity ~= self then 
			if Entity.isTouching(self, entity) then
				if (not (self.friendly ~= true and entity.friendly ~= true) and not (self.friendly == true and entity.friendly == true)) then
					Entity.loseHealth(self, entity.damage)
					Entity.loseHealth(entity, self.damage)
				end
			end
		end
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

function Entity.removeIfOutOfBounds(self, dt)
	if not Entity.inBounds(self) then
		Entity.remove(self)
	end
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


function Entity.getSlope(self, target)
	return (self.y - self.target.y) / (self.x - self.target.x)
end

function Entity.distance(self, target)
	local dx = self.y - target.y
	local dy = self.x - target.x
	return math.sqrt(math.pow(dx, 2) + math.pow(dy, 2))
end

function Entity.shootSpray(self)
	local orientation = 0
	Entity.add(self.bulletType(self.x, self.y, 0.5, 0.5, orientation, false))
	Entity.add(self.bulletType(self.x, self.y, 0.5, -0.5, orientation, false))
	Entity.add(self.bulletType(self.x, self.y, -0.5, 0.5, orientation, false))
	Entity.add(self.bulletType(self.x, self.y, -0.5, -0.5, orientation, false))
	Entity.add(self.bulletType(self.x, self.y, 1, 0, orientation, false))
	Entity.add(self.bulletType(self.x, self.y, 0, -1, orientation, false))
	Entity.add(self.bulletType(self.x, self.y, -1, 0, orientation, false))
	Entity.add(self.bulletType(self.x, self.y, -1, 0, orientation, false))
end

function Entity.follow(self, dt)
	local distance = Entity.distance(self, self.target)
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
	self.dx, self.dy = dx, dy
end

function Entity.removeIfDead(self)
	if not Entity.isAlive(self) then
		if self.points then player.score = player.score + self.points end
		Entity.remove(self)
	end
end

function Entity.shootStraight(self)
	local slope = Entity.getSlope(self, self.target)
	local distance = Entity.distance(self, self.target) 
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
	Entity.add(self.bulletType(self.x, self.y, dx, dy, orientation, false))
end

function Entity.shootBeam(self)
	local slope = Entity.getSlope(self, self.target)
	local distance = Entity.distance(self, self.target)
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
	Entity.add(self.bulletType(self.x, self.y, dx, dy, orientation, false))
	Entity.add(self.bulletType(self.x, self.y, dx - 0.10, dy - 0.10, orientation, false))
	Entity.add(self.bulletType(self.x, self.y, dx + 0.10, dy + 0.10, orientation, false))
end

