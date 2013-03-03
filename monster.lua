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
