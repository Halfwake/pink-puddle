require 'util'
require 'resource'

Monster = {}
Monster.batch = lobe.graphics.newSpriteBatch(IMAGE.monster, MAX_BULLETS, "stream")

function Monster.new(x, y)
	newMonster = table.shallow_copy(monsterTemplate)	
	newMonster.x = x
	newMonster.y = y
	self.orientation = 0
	return newMonster
end

monsterTemplate = {}

function monsterTemplate:move(dx, dy)
	self.x = self.x + dx
	self.y = self.y + dy
end

function monsterTemplate:update()
	Monster.batch:add(self.x, self.y self.orientation)
end

function monsterTemplate:shoot(target)
end
