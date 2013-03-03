require 'color'
require 'const'
require 'util'
require 'monster'
require 'bullet'
require 'player'

function love.load()
	math.randomseed(os.time())
	love.graphics.setCaption("Pink Puddle")
	love.graphics.setBackgroundColor(LightPink)
	player = Player.new(0, 0)
	monsters = Monster.monsters
	monsterCount = 0
	bullets = Monster.monsters
	bulletCount = 0
	monsterSpawnDelta = SPAWN_DELAY
end

function love.draw()
	for _, bullet in pairs(bullets) do bullet:addBatch() end
	for _, monster in pairs(monsters) do monster:addBatch() end
	love.graphics.draw(Bullet.batch)
	love.graphics.draw(Monster.batch)
	player:draw()
	Bullet.batch:clear()
	Monster.batch:clear()
end

function love.update(dt)
	makeMonster(dt)
	for _, bullet in pairs(bullets) do
		local dead = bullet:update(dt)
		if dead then bullets[dead] = nil end
	end
	for _, monster in pairs(monsters) do
		local dead = monster:update(dt, player)
		if dead then monsters[dead] = nil end
	end 
end

function makeMonster(dt)
	if monsterCount < MAX_MONSTERS then
		if monsterSpawnDelta > 0 then
			monsterSpawnDelta = monsterSpawnDelta - dt
		else
			monsterSpawnDelta = SPAWN_DELAY
			monsterCount = monsterCount + 1
			table.insert(monsters, Monster.new(math.randint(0, love.graphics.getWidth()), math.randint(0, love.graphics.getHeight())))		
		end
	end
end
