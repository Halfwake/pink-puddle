require 'util'
require 'const'
require 'resource'

Monster = {}
Monster.monsters = {}
Monster.batch = love.graphics.newSpriteBatch(IMAGE.monster, MAX_BULLETS, "stream")

local monsterTemplate = {}

function monsterTemplate:move(dt, dx, dy)
	self.x = self.x + dx * dt
	self.y = self.y + dy * dt
end

function monsterTemplate:update(dt)
	if self.fireDelay > 0 then
		self.fireDelay = self.fireDelay - dt
	else
		self.fireDelay = FIRE_DELAY
		self:shoot()
	end
	if not self:alive() then return self end
end

function monsterTemplate:alive()
	return self.health >= 0
end

function monsterTemplate:addBatch()
	Monster.batch:add(math.round(self.x), math.round(self.y), self.orientation)
end

function monsterTemplate:shoot()
	local slope = (self.y - self.target.y) / (self.x - self.target.x)
	local orientation = math.atan(slope)
	local dx
	local dy
	if self.target.y - self.y == 0 then
		dy = 0
	else
		dy = 1 / (self.target.y - self.y) 
	end
	if self.target.x - self.x == 0 then
		dx = 0
	else
		dx = 1 / (self.target.x - self.x)
	end
	table.insert(Bullet.bullets, Bullet.new(self.x, self.y, dx, dy, orientation))
end

function Monster.new(x, y, target)
	local newMonster = table.shallow_copy(monsterTemplate)	
	newMonster.x = x
	newMonster.y = y
	newMonster.target = target
	newMonster.orientation = 0
	newMonster.health = MONSTER_HEALTH
	newMonster.fireDelay = 0
	return newMonster
end
