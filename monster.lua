require 'util'
require 'const'
require 'resource'
require 'bullet'

Monster = {}
Monster.monsters = {}
Monster.batches = {
			YellowBouncer = love.graphics.newSpriteBatch(IMAGE.yellow_bouncer, MAX_MONSTERS, 'stream'),
			GreenChaser = love.graphics.newSpriteBatch(IMAGE.green_chaser, MAX_MONSTERS, 'stream'),
			OctoShot = love.graphics.newSpriteBatch(IMAGE.octo_shooter, MAX_MONSTERS, 'stream'),
			DemonPig = love.graphics.newSpriteBatch(IMAGE.demon_pig, MAX_MONSTERS, 'stream'),
		  }

local monsterTemplate = {}

function monsterTemplate:move(dt, dx, dy)
	self.x = self.x + dx * dt * self.speed
	self.y = self.y + dy * dt * self.speed
end

function monsterTemplate:takeHit(bullet)
	self.health = self.health - bullet.damage
end

function monsterTemplate:update(dt)
	if self.fireDelta > 0 then
		self.fireDelta = self.fireDelta - dt
	else
		self.fireDelta = self.fireDelay 
		self:shoot()
	end
	if self:touching(self.target) then
		self:loseHealth(self.health)
		self.target:loseHealth(self.damage)
	end
	local alive = self:alive()
	if not alive then
		return self
	end
end

function monsterTemplate:alive()
	return self.health > 0
end

function monsterTemplate:addBatch()
	local image = self.batchPointer:getImage()
	self.batchPointer:add(math.round(self.x - image:getWidth() / 2), math.round(self.y - image:getHeight()), self.orientation)
end

function monsterTemplate:loseHealth(damage)
	self.health = self.health - damage
end

function monsterTemplate:touching(target)
	local distance_squared = math.pow(self.y - target.y, 2) +  math.pow(self.x - target.x, 2)
	local radius_squared
	if target.type == 'player' then
		radius_squared = math.pow(target.image:getWidth() / 3, 2)
	elseif target.type == 'monster' then
		radius_squared = math.pow(target.batchPointer:getImage():getWidth(), 2)
	end
	if radius_squared >= distance_squared then
		return true
	end
	return false
end

function monsterTemplate:shoot()
	local slope = (self.y - self.target.y) / (self.x - self.target.x)
	local distance = math.sqrt(math.pow(self.y - self.target.y, 2) + math.pow(self.x - self.target.x, 2))
	local orientation = math.atan(self.y - self.target.y, self.x - self.target.x) --fix this later
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
	table.insert(Bullet.bullets, self.bulletType.new(self.x, self.y, dx, dy, orientation, false))
end

function Monster.new(x, y, target)
	local newMonster = table.shallow_copy(monsterTemplate)	
	newMonster.type = 'monster'
	newMonster.x = x
	newMonster.y = y
	newMonster.target = target
	newMonster.orientation = 0
	newMonster.health = MONSTER_HEALTH
	newMonster.fireDelta = 0
	newMonster.fireDelay = 0
	newMonster.speed = 150
	newMonster.damage = 0
	newMonster.points = 0
	newMonster.health = 1
	return newMonster
end

Monster.YellowBouncer = {}
local yellowBouncerTemplate = {}

function yellowBouncerTemplate:update(dt)
	if self.x < 0 or self.x > love.graphics.getWidth() then
		self.dx = -self.dx 
	end
	if self.y < 0 or self.y > love.graphics.getHeight() then
		self.dy = -self.dy
	end
	self:move(dt, self.dx, self.dy)
	return monsterTemplate.update(self, dt)
end
	
function Monster.YellowBouncer.new(x, y, target)
	local newYellowBouncer = Monster.new(x, y, target)
	newYellowBouncer = table.join(newYellowBouncer, yellowBouncerTemplate)
	newYellowBouncer.dx = math.randsin() / 2
	newYellowBouncer.dy = math.randsin() / 2
	newYellowBouncer.speed = 150	
	newYellowBouncer.bulletType = Bullet.YellowShoot
	newYellowBouncer.batchPointer = Monster.batches.YellowBouncer
	newYellowBouncer.fireDelay = 1.50
	newYellowBouncer.damage = 50
	newYellowBouncer.points = 50
	newYellowBouncer.health = 25
	return newYellowBouncer
end

Monster.GreenChaser = {}
local greenChaserTemplate = {}

function greenChaserTemplate:shoot()
end

Monster.follow = function(self, dt)
	local distance = math.sqrt(math.pow(self.y - self.target.y, 2) + math.pow(self.x - self.target.x, 2))
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
	self:move(dt, dx, dy)
	return monsterTemplate.update(self, dt)
end

greenChaserTemplate.update = Monster.follow

function Monster.GreenChaser.new(x, y, target)
	local newGreenChaser = Monster.new(x, y, target)
	newGreenChaser = table.join(newGreenChaser, greenChaserTemplate)
	newGreenChaser.speed = 210
	newGreenChaser.batchPointer = Monster.batches.GreenChaser
	newGreenChaser.damage = 15
	newGreenChaser.points = 25
	newGreenChaser.health = 1
	return newGreenChaser
end

Monster.OctoShot = {}
local octoShotTemplate = {}

function Monster.shootSpray(self)
	local orientation = 0
	table.insert(Bullet.bullets, self.bulletType.new(self.x, self.y, 0.5, 0.5, orientation, false))
	table.insert(Bullet.bullets, self.bulletType.new(self.x, self.y, -0.5, -0.5, orientation, false))
	table.insert(Bullet.bullets, self.bulletType.new(self.x, self.y, 0.5, -0.5, orientation, false))
	table.insert(Bullet.bullets, self.bulletType.new(self.x, self.y, -0.5, 0.5, orientation, false))
	table.insert(Bullet.bullets, self.bulletType.new(self.x, self.y, 0, 1, orientation, false))
	table.insert(Bullet.bullets, self.bulletType.new(self.x, self.y, 0, -1, orientation, false))
	table.insert(Bullet.bullets, self.bulletType.new(self.x, self.y, 1, -1, orientation, false))
	table.insert(Bullet.bullets, self.bulletType.new(self.x, self.y, 1, 1, orientation, false))
end

function Monster.shootBeam(self)
	local slope = (self.y - self.target.y) / (self.x - self.target.x)
	local distance = math.sqrt(math.pow(self.y - self.target.y, 2) + math.pow(self.x - self.target.x, 2))
	local orientation = math.atan(self.y - self.target.y, self.x - self.target.x) --fix this later
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
	table.insert(Bullet.bullets, self.bulletType.new(self.x, self.y, dx, dy, orientation, false))
	table.insert(Bullet.bullets, self.bulletType.new(self.x, self.y, dx - 0.10, dy + 0.10, orientation, false))
	table.insert(Bullet.bullets, self.bulletType.new(self.x, self.y, dx + 0.10, dy - 0.10, orientation, false))
end

octoShotTemplate.shoot = Monster.shootSpray

octoShotTemplate.update = Monster.follow

function Monster.OctoShot.new(x, y, target)
	local newOctoShot = Monster.new(x, y, target)
	newOctoShot = table.join(newOctoShot, octoShotTemplate)
	newOctoShot.speed = 100
	newOctoShot.damage = 25
	newOctoShot.points = 75
	newOctoShot.batchPointer = Monster.batches.OctoShot
	newOctoShot.bulletType = Bullet.YellowShoot
	newOctoShot.fireDelay = 5
	newOctoShot.health = 50
	return newOctoShot
end

Monster.DemonPig = {}
local demonPigTemplate = {}

function demonPigTemplate:shoot()
	local orientation = 0
	if self.shootMode == 'beam' then
		self:shootBeam()
	elseif self.shootMode == 'spray' then
		self:shootSpray()
	end
end

function demonPigTemplate:update(dt)
	if self.fireDelta > 0 then
		self.fireDelta = self.fireDelta - dt
	else
		self.fireDelta = self.fireDelay 
		if self.shootMode ~= 'spray' then
			self.shootMode = 'spray'
		else
			self.shootMode = 'beam'
		end
		self:shoot()
	end
	if self:touching(self.target) then
		self:loseHealth(self.health)
		self.target:loseHealth(self.damage)
	end
	local alive = self:alive()
	if not alive then
		return self
	end
end

function Monster.DemonPig.new(x, y, target)
	local newDemonPig = Monster.new(x, y, target)
	newDemonPig = table.join(newDemonPig, demonPigTemplate)
	newDemonPig.speed = 50
	newDemonPig.damage = 50
	newDemonPig.points = 500
	newDemonPig.batchPointer = Monster.batches.DemonPig
	newDemonPig.bulletType = Bullet.YellowShoot
	newDemonPig.fireDelay = 1.5
	newDemonPig.health = 250
	newDemonPig.shootSpray = Monster.shootSpray
	newDemonPig.shootBeam = Monster.shootBeam
	return newDemonPig
end

Monster.Constructors = {
				YellowBouncer = Monster.YellowBouncer.new,
				GreenChaser = Monster.GreenChaser.new,
				OctoShot = Monster.OctoShot.new,
				DemonPig = Monster.DemonPig.new,
		       }
