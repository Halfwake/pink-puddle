require 'util'
require 'resource'

Player = {}

local playerTemplate = {}

function playerTemplate:draw()
	love.graphics.draw(self.image, self.x - self.image:getWidth() / 2, self.y - self.image:getHeight() / 2)
end

function Player.new(x, y)
	local newPlayer = table.shallow_copy(playerTemplate)	
	newPlayer.x = x
	newPlayer.y = y
	newPlayer.image = IMAGE.player
	return newPlayer
end

