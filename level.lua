Level = {}

function Level.new()
	local newLevel = {}
	return newLevel
end

Level[1] = function()
	local newLevel = Level.new()
	newLevel.YellowBouncer = 20
	newLevel.GreenChaser = 5
	newLevel.maxMonsters = 5
	newLevel.monsterSpawnTime = 2
	return newLevel
end

Level[2] = function()
	local newLevel = Level.new()
	newLevel.OctoShot = 8
	newLevel.YellowBouncer = 25
	newLevel.DemonPig = 2
	newLevel.maxMonsters = 10
	newLevel.monsterSpawnTime = 2
	return newLevel
end

Level[3] = function()
	local newLevel = Level.new()
	newLevel.YellowBouncer = 10
	newLevel.OctoShot = 10
	newLevel.GreenChaser = 10
	newLevel.maxMonsters = 25
	newLevel.monsterSpawnTime = 0.50
	return newLevel
end
