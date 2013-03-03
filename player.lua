require 'util'
require 'resource'

Player = {}

local playerTemplate = {}

function playerTemplate:draw()
	love.graphics.draw(self.image, math.round(self.x - self.image:getWidth() / 2), math.round(self.y - self.image:getHeight() / 2))
end

function playerTemplate:update(dt)
	local dx, dy
	dx, dy = self:getInput(dt)
	self:move(dx, dy, dt)
end

function playerTemplate:move(dx, dy, dt)
	self.x = self.x + dx * dt * self.speed
	self.y = self.y + dy * dt * self.speed
end

function playerTemplate:getInput(dt)
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

function Player.new(x, y)
	local newPlayer = table.shallow_copy(playerTemplate)	
	newPlayer.x = x
	newPlayer.y = y
	newPlayer.speed = 200
	newPlayer.image = IMAGE.player
	return newPlayer
end

