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
	player = Player.new(30, 30)
	monsters = Monster.monsters
	monsterCount = 0
	bullets = Bullet.bullets
	bulletCount = 0
	monsterSpawnDelta = SPAWN_DELAY
end

function love.draw()
	love.graphics.clear()
	for _, bullet in pairs(bullets) do bullet:addBatch() end
	for _, monster in pairs(monsters) do monster:addBatch() end
	love.graphics.draw(Monster.batch)
	love.graphics.draw(Bullet.batch)
	Bullet.batch:clear()
	Monster.batch:clear()
	player:draw()
end

function love.update(dt)
	player:update(dt)
	makeMonster(dt)
	for _, bullet in pairs(bullets) do
		local dead = bullet:update(dt)
		if dead then
			bullets[dead] = nil
			bulletCount = bulletCount - 1
		end
	end
	for _, monster in pairs(monsters) do
		local dead = monster:update(dt)
		if dead then
			monsters[dead] = nil
			monsterCount = monsterCount - 1
		end
	end 
end

function makeMonster(dt)
	if monsterCount < MAX_MONSTERS then
		if monsterSpawnDelta > 0 then
			monsterSpawnDelta = monsterSpawnDelta - dt
		else
			monsterSpawnDelta = SPAWN_DELAY
			monsterCount = monsterCount + 1
			table.insert(monsters, Monster.new(math.randint(0, love.graphics.getWidth()), math.randint(0, love.graphics.getHeight()), player))		
		end
	end
end
