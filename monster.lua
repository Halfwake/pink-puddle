require 'util'

Monster = {}
Monster.batch = lobe.graphics.newSpriteBatch(IMAGE.monster, MAX_BULLETS, "stream")

function Monster.new(x, y)
	newMonster = table.shallow_copy(monsterTemplate)	
	newMonster.x = x
	newMonster.y = y
	return newMonster
end

monsterTemplate = {}

function monsterTemplate:move(dx, dy)
	self.x = self.x + dx
	self.y = self.y + dy
end

function monsterTemplate:update()
end

function monsterTemplate:shoot(target)
end
