require 'util'
require 'const'
require 'resource'

Bullet = {}
Bullet.bullets = {}
Bullet.batches = {
			YellowShoot = love.graphics.newSpriteBatch(IMAGE.yellow_shoot, MAX_BULLETS, "stream"),
			IceBall = love.graphics.newSpriteBatch(IMAGE.ice_ball, MAX_BULLETS, "stream"),
		 }

local bulletTemplate = {}

function bulletTemplate:move(dt)
	self.x = self.x + self.dx * dt * self.speed
	self.y = self.y + self.dy * dt * self.speed
end

function bulletTemplate:update(dt)
	self:move(dt)
	if not self:alive() then return self end
end

function bulletTemplate:addBatch()
	local image = self.batchPointer:getImage()
	self.batchPointer:add(math.round(self.x - image:getWidth() / 2), math.round(self.y - image:getHeight() / 2), self.orientation)
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

function bulletTemplate:enemy(target)
	if not self.friendly and target.type == 'player' then
		return true
	elseif self.friendly and target.type == 'monster' then
		return true
	end
	return false
end

function bulletTemplate:touching(target)
	local distance_squared
	local radius_squared
	if target.type == 'player' then
		distance_squared = math.pow(self.y - target.y, 2) +  math.pow(self.x - target.x, 2)
		radius_squared = math.pow(target.image:getWidth() / 3, 2)
	elseif target.type == 'monster' then
		distance_squared = math.pow(self.y - (target.y - self.batchPointer:getImage():getHeight() / 2), 2) +  math.pow(self.x - (target.x - self.batchPointer:getImage():getWidth() / 2), 2)
		radius_squared = math.pow(target.batchPointer:getImage():getWidth() / 2, 2)
	end
	if radius_squared >= distance_squared then
		return true
	end
	return false
end

function Bullet.new(x, y, dx, dy, orientation, friendly)
	local newBullet = table.shallow_copy(bulletTemplate)
	newBullet.x = x
	newBullet.y = y
	newBullet.dx = dx
	newBullet.dy = dy
	newBullet.orientation = 0
	newBullet.speed = 250
	newBullet.damage = 10
	newBullet.friendly = friendly
	return newBullet
end

Bullet.YellowShoot = {}
local yellowShootTemplate = {}

function Bullet.YellowShoot.new(x, y, dx, dy, orientation, friendly)
	local newYellowShoot = Bullet.new(x, y, dx, dy, orientation, friendly)
	newYellowShoot = table.join(newYellowShoot, yellowShootTemplate)
	newYellowShoot.batchPointer = Bullet.batches.YellowShoot
	return newYellowShoot
end

Bullet.IceBall = {}
local iceBallTemplate = {}

function Bullet.IceBall.new(x, y, dx, dy, orientation, friendly)
	local newIceBall = Bullet.new(x, y, dx, dy, orientation, friendly)
	newIceBall = table.join(newIceBall, iceBallTemplate)
	newIceBall.batchPointer = Bullet.batches.IceBall
	newIceBall.speed = 350
	newIceBall.damage = 15
	return newIceBall
end

Bullet.Constructors = {
				YellowShoot = Bullet.YellowShoot.new,
				IceBall = Bullet.IceBall.new,
		      }

