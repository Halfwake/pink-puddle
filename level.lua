Level = {}

function Level.new()
	local newLevel = {}
	return newLevel
end

function Level.One()
	local newLevel = Level.new()
	newLevel.YellowBouncer = 30
	newLevel.maxMonsters = 10
	newLevel.monsterSpawnTime = 2
	return newLevel
end

function nextLevel()
end
