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

function monsterTemplate:update(dt, target)
	if self.fireDelay > 0 then
		self.fireDelay = self.fireDelay - dt
	else
		self.fireDelay = FIRE_DELAY
		self:shoot(target)
	end
	if not self:alive() then return self end
end

function monsterTemplate:alive()
	return self.health >= 0
end

function monsterTemplate:addBatch()
	Monster.batch:add(math.round(self.x), math.round(self.y), self.orientation)
end

function monsterTemplate:shoot(target)
	local slope = (self.y - target.y) / (self.x - target.x)
	local orientation = math.tan(slope)
	local dx
	local dy
	dx, dy = math.sin(slope), math.cos(slope) 
	table.insert(Monster.monsters, Bullet.new(self.x, self.y, dx, dy, orientation))
end

function Monster.new(x, y)
	newMonster = table.shallow_copy(monsterTemplate)	
	newMonster.x = x
	newMonster.y = y
	newMonster.orientation = 0
	newMonster.health = MONSTER_HEALTH
	newMonster.fireDelay = FIRE_DELAY
	return newMonster
end
