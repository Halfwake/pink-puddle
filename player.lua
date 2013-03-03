require 'util'
require 'resource'

Player = {}

function Player.new(x, y)
	newPlayer = table.shallow_copy(monsterTemplate)	
	newPlayer.x = x
	newPlayer.y = y
	newPlayer.image = IMAGE.player
	return newPlayer
end

playerTemplate = {}

function playerTempalte:draw()
	love.graphics.draw(self.image, self.x + self.image:getWidth(), self.y + self.image:getHeight())
end
