require 'util'
require 'const'
require 'resource'

Bullet = {}
Bullet.batch = lobe.graphics.newSpriteBatch(IMAGE.bullet, MAX_BULLETS, "stream")
function Bullet.new(x, y, dx, dy)
	newBullet = table.shallow_copy(bulletTemplate)
	newBullet.x = x
	newBullet.y = y
	newBullet.dx = dx
	newBullet.dy = dy
	self.orientation = 0
	return newBullet
end

bulletTemplate = {}

function bulletTemplate:move()
	self.x = self.x + self.dx
	self.y = self.y + self.dy
end

function bulletTempalte:update()
	self.move()
	Bullet.batch:add(self.x, self.y self.orientation)
end

function bulletTemplate:setDelta(dx, dy)
	self.dx = dx
	self.dy = dy
end
