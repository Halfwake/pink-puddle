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
		for _, entity in pairs(Entity.entities) do
			entity:update(dt)
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
		levelCount = 0
		Entity.monsterCount = 0
		bulletCount = 0
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
	if Entity.monsterCount < MAX_MONSTERS and Entity.monsterCount < level.maxMonsters then
		if monsterSpawnDelta > 0 then
			monsterSpawnDelta = monsterSpawnDelta - dt
		else
			monsterSpawnDelta = level.monsterSpawnTime
			Entity.monsterCount = Entity.monsterCount + 1
			local enemiesLeft = false
			for index, constructor in pairs(Entity.Constructors) do
				if level[index] and level[index] > 0 then
					local newEntity = constructor(0, 0, player)
					local width, height
					width, height = newEntity.batchPointer:getImage():getWidth(), newEntity.batchPointer:getImage():getHeight()
					local x, y
					x, y = math.randint(width, love.graphics.getWidth()), math.randint(height, love.graphics.getHeight())
					while math.distance(x, y, player.x, player.y) <= MIN_SPAWN_DISTANCE do
						x, y = math.randint(0, love.graphics.getWidth()), math.randint(0, love.graphics.getHeight())
					end
					newEntity.x, newEntity.y = x, y
					Entity.add(newEntity)
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
