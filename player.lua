Player = {}

function Player.new(x, y)
	newPlayer = table.shallow_copy(monsterTemplate)	
	newPlayer.x = x
	newPlayer.y = y
	return newPlayer
end

