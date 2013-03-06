require 'color'
require 'const'
require 'util'
require 'monster'
require 'bullet'
require 'player'
require 'level'

function love.load()
	math.randomseed(os.time())
	love.graphics.setCaption("Pink Puddle")
	love.graphics.setBackgroundColor(LightPink)
	monsterCount = 0
	bulletCount = 0
	levelCount = 0
	monsterSpawnDelta = SPAWN_DELAY
	SOUND.play_theme:setLooping(true)
	gameMode = 'start'
end

function love.draw()
	love.graphics.clear()
	if gameMode == 'play' or gameMode == 'pause' then
		Entity.draw()
		player:draw()
		love.graphics.print('Score: ' .. tostring(player.score), 0, 0)
		love.graphics.print('Health: ' .. tostring(player.health), 100, 0)
	elseif gameMode == 'start' then
		love.graphics.draw(IMAGE.start_screen)
	elseif gameMode == 'gameover' then
		love.graphics.draw(IMAGE.gameover_screen)
		love.graphics.print('Final Score: ' .. tostring(player.score), love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0)
	end	
end

function love.keypressed(key, unicode)
	if key == 'p' then
		if gameMode == 'pause' then
			gamePlay()
		elseif gameMode == 'play' then
			gamePause()
		end
	end
	if gameMode == 'start' or gameMode == 'gameover' then
		if key == 'return' then gamePlay() end
	end
end

function love.update(dt)
	if gameMode == 'play' then
		if not player:isAlive() then
			gameOver()
			return
		end
		if hasLevelStarted(dt) then makeMonster(dt) end
		player:update(dt)
		collisionUpdate(dt)	
	end
end

function collisionUpdate(dt)
	for _, entity in pairs(Entity.entities) do
		entity:update(dt)
	end
	for _, entityOne in pairs(Entity.entities) do
		if entityOne:isTouching(player) and not entityOne.friendly and entityOne.damage then
			player:takeHit(entityOne)
		end
	end
	for _, entityOne in pairs(Entity.entities) do
		for _, entityTwo in pairs(Entity.entities) do
			if entityOne:isTouching(entityTwo) and entityOne.friendly ~= entityTwo.friendly then
				if entityOne.health and entityTwo.damage then
					entityOne.health = entityOne.health - entityTwo.damage
				else
					Entity.remove(entityOne)
				end
				if entityTwo.health and entityTwo.damage then
					entityTwo.health = entityTwo.health - entityOne.damage
				else
					Entity.remove(entityTwo)
				end
			end
		end
	end
end

function hasLevelStarted(dt)
	if levelDelta then
		if levelDelta <= 0 then
			love.audio.play(SOUND.next_level)
			levelDelta = nil
		else
			levelDelta = levelDelta - dt
		end
		return false
	end
	return true
end

function nextLevel()
	levelCount = levelCount + 1
	levelDelta = LEVEL_DELAY
	local nextLevelConstructor = Level[levelCount]
	if nextLevelConstructor then level = nextLevelConstructor() else gameWon() end
end

function gameWon()
	gameOver()
end

function gameOver()
	gameMode = 'gameover'
	Entity.entities = {}
	levelCount = 0
end


function gamePlay()
	if gameMode == 'start' then
		love.audio.play(SOUND.play_theme)
	end
	if gameMode ~= 'pause' then
		player = Player.new(30, 30)
		nextLevel()
	end
	gameMode = 'play'
	love.audio.setVolume(1.0)
end

function gamePause()
	gameMode = 'pause'
	love.audio.setVolume(0.4)
end


function makeMonster(dt)
	if monsterCount < MAX_MONSTERS and monsterCount < level.maxMonsters then
		if monsterSpawnDelta > 0 then
			monsterSpawnDelta = monsterSpawnDelta - dt
		else
			monsterSpawnDelta = level.monsterSpawnTime
			monsterCount = monsterCount + 1
			local enemiesLeft = false
			local mixedConstructors = table.shallow_copy(Entity.Constructors)
			for index, constructor in pairs(mixedConstructors) do
				if level[index] and level[index] > 0 then
					Entity.add(constructor(math.randint(0, love.graphics.getWidth()), math.randint(0, love.graphics.getHeight()), player))	
					level[index] = level[index] - 1
					enemiesLeft = true
					break
				end
			end
			if not enemiesLeft then
				local entitiesLeftInLevel
				for _, _ in pairs(Entity.entities) do
					entitiesLeftInLevel = true
				end
				if not entitiesLeftInLevel then nextLevel() end
			end
		end
	end
end
