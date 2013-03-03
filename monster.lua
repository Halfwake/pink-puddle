require 'util'
require 'resource'

Monster = {}
Monster.batch = love.graphics.newSpriteBatch(IMAGE.monster, MAX_BULLETS, "stream")

local monsterTemplate = {}

function monsterTemplate:move(dx, dy)
	self.x = self.x + dx
	self.y = self.y + dy
end

function monsterTemplate:update()
	Monster.batch:add(self.x, self.y, self.orientation)
end

function monsterTemplate:shoot(target)
end

function Monster.new(x, y)
	newMonster = table.shallow_copy(monsterTemplate)	
	newMonster.x = x
	newMonster.y = y
	newMonster.orientation = 0
	return newMonster
end
