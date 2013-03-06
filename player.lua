require 'util'
require 'resource'

Player = {}

local playerTemplate = {}

function playerTemplate:draw()
	local r, g, b, a = love.graphics.getColor()
	local old_mode love.graphics.getColorMode()
	love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.color[4])
	love.graphics.draw(self.image, math.round(self.x - self.image:getWidth() / 2), math.round(self.y - self.image:getHeight() / 2))
	love.graphics.setColor(r, g, b, a)
	love.graphics.getColorMode(old_mode)
end

function playerTemplate:update(dt)
	local dx, dy
	dx, dy = self:getInput(dt)
	self:move(dx, dy, dt)
	self.shootDelta = self.shootDelta - dt
	if self.health <= 0 then
		return self
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

function playerTemplate:getInput(dt)
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
	return dx, dy
end

function playerTemplate:shootBullet(dx, dy)
	local orientation = 0
	table.insert(Bullet.bullets, Bullet.Constructors.IceBall(self.x, self.y, dx, dy, orientation, true))
	self.shootDelta = PLAYER_FIRE_DELAY
end


function playerTemplate:takeHit(bullet)
	self:loseHealth(bullet.damage)
end

function playerTemplate:loseHealth(damage)
	self.health = self.health - damage
	self.injuryFlickerDelta = INJURY_DELAY
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
	local r, g, b, a = love.graphics.getColor()
	newPlayer.color = {r, g, b, a}
	return newPlayer
end

