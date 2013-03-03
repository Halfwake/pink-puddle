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

function playerTempalte:
end
