require 'util'
require 'resource'
require 'entity'

Player = {}

local playerTemplate = {}

function playerTemplate:draw()
	local r, g, b, a = love.graphics.getColor()
	local old_mode love.graphics.getColorMode()

	local canDraw = false
	if not player.injuryFlickerDelta or player.injuryFlickerDelta < 0 then
		canDraw = true	
	else
		if player.injurySwitch then
			canDraw = true
		end
		player.injurySwitch = not player.injurySwitch
	end

	if canDraw then	
		love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.color[4])
		love.graphics.draw(self.image, math.round(self.x - self.image:getWidth() / 2), math.round(self.y - self.image:getHeight() / 2))
		love.graphics.setColor(r, g, b, a)
		love.graphics.getColorMode(old_mode)
	end
end

function playerTemplate:update(dt)
	self:reactInput(dt)
	self.shootDelta = self.shootDelta - dt
	if self.injuryFlickerDelta then 
		player.injuryFlickerDelta = player.injuryFlickerDelta - dt
	end
end

function playerTemplate:move(dx, dy, dt)
	self.x = self.x + dx * dt * self.speed
	self.y = self.y + dy * dt * self.speed
	if self.x - self.image:getWidth() / 2 < 0 then
		self.x = self.image:getWidth() / 2 
	elseif self.x + self.image:getWidth() / 2 > love.graphics.getWidth() then
		self.x = love.graphics.getWidth() - self.image:getWidth() / 2
	end
	if self.y - self.image:getHeight() / 2 < 0 then
		self.y = self.image:getHeight() / 2
	elseif self.y + self.image:getHeight() / 2 > love.graphics.getHeight() then
		self.y = love.graphics.getHeight() - self.image:getHeight() / 2
	end
end

function playerTemplate:reactInput(dt)
	if player.shootDelta <= 0 then
		if love.keyboard.isDown('w') then
			player:shootBullet(0, -1)
		elseif love.keyboard.isDown('s') then
			player:shootBullet(0, 1)
		elseif love.keyboard.isDown('a') then
			player:shootBullet(-1, 0)
		elseif love.keyboard.isDown('d') then
			player:shootBullet(1, 0)
		end
	end	
	local dx, dy = 0, 0
	if love.keyboard.isDown('up') then
		dy = -1
	end
	if love.keyboard.isDown('down') then
		dy = 1
	end
	if love.keyboard.isDown('left') then
		dx = -1
	end
	if love.keyboard.isDown('right') then
		dx = 1
	end
	self:move(dx, dy, dt)
end

function playerTemplate:shootBullet(dx, dy)
	local orientation = 0
	Entity.add(Entity.Constructors.IceBall(self.x, self.y, dx, dy, orientation, nil, true))
	self.shootDelta = PLAYER_FIRE_DELAY
end


function playerTemplate:takeHit(bullet)
	self:loseHealth(bullet.damage)
	Entity.remove(bullet)
end

function playerTemplate:loseHealth(damage)
	self.health = self.health - damage
	self.injuryFlickerDelta = INJURY_DELAY
end

function playerTemplate:isAlive()
	return self.health > 0
end

function Player.new(x, y)
	local newPlayer = table.shallow_copy(playerTemplate)	
	newPlayer.type = 'player'
	newPlayer.x = x
	newPlayer.y = y
	newPlayer.speed = 200
	newPlayer.image = IMAGE.player
	newPlayer.health = 50
	newPlayer.score = 0
	newPlayer.shootDelta = 0
	newPlayer.injuryFlickerDelta = 0
	newPlayer.injurtySwitch = false
	newPlayer.friendly = true
	local r, g, b, a = love.graphics.getColor()
	newPlayer.color = {r, g, b, a}
	return newPlayer
end

