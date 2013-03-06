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
	monsters = Monster.monsters
	monsterCount = 0
	bullets = Bullet.bullets
	bulletCount = 0
	levelCount = 0
	monsterSpawnDelta = SPAWN_DELAY
	SOUND.play_theme:setLooping(true)
	gameMode = 'start'
end

function love.draw()
	love.graphics.clear()
	if gameMode == 'play' or gameMode == 'pause' then
		for _, bullet in pairs(bullets) do bullet:addBatch() end
		for _, monster in pairs(monsters) do monster:addBatch() end
		for _, batch in pairs(Monster.batches) do
			love.graphics.draw(batch)
			batch:clear()
		end
		for _, batch in pairs(Bullet.batches) do
			love.graphics.draw(batch)
			batch:clear()
		end
		if player.injuryFlickerDelta < 0 then
			player:draw()
		else
			if player.injurySwitch then
				player:draw()
			end
			player.injurySwitch = not player.injurySwitch
		end
		love.graphics.print('Score: ' .. tostring(player.score), 0, 0)
		love.graphics.print('Health: ' .. tostring(player.health), 100, 0)
	elseif gameMode == 'start' then
		love.graphics.draw(IMAGE.start_screen)
	elseif gameMode == 'gameover' then
		love.graphics.draw(IMAGE.gameover_screen)
		love.graphics.print('Final Score: ' .. tostring(player.score), love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0)
	end	
end

function love.update(dt)
	if gameMode == 'play' then
		player.injuryFlickerDelta = player.injuryFlickerDelta - dt
		if player:update(dt) then
			gameOver()
			return
		end
		if levelDelta then
			if levelDelta <= 0 then
				love.audio.play(SOUND.next_level)
				levelDelta = nil
			else
				levelDelta = levelDelta - dt
			end
		end
		if not levelDelta then makeMonster(dt) end
		for _, bullet in pairs(bullets) do
			local dead = bullet:update(dt)
			if bullet:touching(player) and bullet:enemy(player) then
				dead = bullet
				local dead_player = player:takeHit(bullet)
			end
			if dead then
				bullets[table.index(bullets, dead)] = nil
				bulletCount = bulletCount - 1
			end
		end
		for _, monster in pairs(monsters) do
			local dead = monster:update(dt)
			for _, bullet in pairs(bullets) do
				if bullet:touching(monster) and bullet:enemy(monster) then
					monster:takeHit(bullet)
					bullets[table.index(bullets, bullet)] = nil
					if monster.health <= 0 then
						player.score = player.score + monster.points
						dead = monster
					end
				end
			end
			if dead then
				monsters[table.index(monsters, dead)] = nil
				monsterCount = monsterCount - 1
			end
		end
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
	Monster.monsters = {}
	monsters = Monster.monsters
	Bullet.bullets = {}
	bullets = Bullet.bullets
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
			local mixedConstructors = table.shallow_copy(Monster.Constructors)
			for index, constructor in pairs(mixedConstructors) do
				if level[index] and level[index] > 0 then
					table.insert(monsters, constructor(math.randint(0, love.graphics.getWidth()), math.randint(0, love.graphics.getHeight()), player))	
					level[index] = level[index] - 1
					enemiesLeft = true
					break
				end
			end
			if not enemiesLeft then
				local enemiesLeftLevel
				for _, _ in pairs(monsters) do
					enemiesLeftLevel = true
				end
				if not enemiesLeftLevel then nextLevel() end
			end
		end
	end
end
