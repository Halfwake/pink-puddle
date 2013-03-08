Level = {}

function Level.new()
	local newLevel = {}
	return newLevel
end

Level[1] = function()
	local newLevel = Level.new()
	newLevel.YellowBouncer = 10
	newLevel.GreenChaser = 5
	newLevel.BatBouncer = 3
	newLevel.maxMonsters = 5
	newLevel.monsterSpawnTime = 1.75
	return newLevel
end

Level[2] = function()
	local newLevel = Level.new()
	newLevel.OctoShot = 5
	newLevel.YellowBouncer = 5
	newLevel.BatBouncer = 3
	newLevel.DemonPig = 3
	newLevel.maxMonsters = 10
	newLevel.monsterSpawnTime = 1.75
	return newLevel
end

Level[3] = function()
	local newLevel = Level.new()
	newLevel.YellowBouncer = 3
	newLevel.OctoShot = 10
	newLevel.GreenChaser = 5
	newLevel.DemonPig = 7
	newLevel.maxMonsters = 25
	newLevel.monsterSpawnTime = 1.25
	return newLevel
end

Level[4] = function()
	local newLevel = Level.new()
	newLevel.Grizz = 10
	newLevel.DemonPig = 2
	newLevel.maxMonsters = 7
	newLevel.monsterSpawnTime = 1.75
	return newLevel
end

Level[5] = function()
	local newLevel = Level.new()
	newLevel.Coobey = 3
	newLevel.BatBouncer = 7
	newLevel.maxMonsters = 7
	newLevel.monsterSpawnTime = 1.50
	return newLevel
end

Level[6] = function()
	local newLevel = Level.new()
	newLevel.DemonPig = 50
	newLevel.maxMonsters = 25
	newLevel.monsterSpawnTime = 0.75
	return newLevel
end
