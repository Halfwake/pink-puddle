require 'util'
require 'const'
require 'resource'

Bullet = {}
Bullet.bullets = {}
Bullet.batch = love.graphics.newSpriteBatch(IMAGE.bullet, MAX_BULLETS, "stream")

local bulletTemplate = {}

function bulletTemplate:move(dt)
	self.x = self.x + (self.dx * dt)
	self.y = self.y + (self.dy * dt)
end

function bulletTemplate:update(dt)
	self:move(dt)
	if not self:alive() then return self end
end

function bulletTemplate:addBatch()
	Bullet.batch:add(math.round(self.x), math.round(self.y), self.orientation)
end

function bulletTemplate:alive()
	if self.x < 0 or self.x > love.graphics.getWidth() or self.y < 0 or self.y > love.graphics.getHeight() then
		return false
	end
	return true
end

function bulletTemplate:setDelta(dx, dy)
	self.dx = dx
	self.dy = dy
end

function Bullet.new(x, y, dx, dy, orientation)
	newBullet = table.shallow_copy(bulletTemplate)
	newBullet.x = x
	newBullet.y = y
	newBullet.dx = dx
	newBullet.dy = dy
	newBullet.orientation = 0
	return newBullet
end

