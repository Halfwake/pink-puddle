require 'util'
require 'const'
require 'resource'
require 'bullet'


Entity.Constructors.YellowBouncer = Entity.newConstructor(
	{'x', 'y', 'target'},
	{
		{loseHealth = Entity.loseHealth, shootStraight = Entity.shootStraight},
		{
			dx = math.randsin() / 2,
			dy = math.randsin() / 2,
			orientation = 0,
			health = 25,
			damage = 50,
			points = 50,
			fireDelay = 1.5, 
			speed = 150
			bulletType = Entity.Constructors.YellowShoot
		}
	},
	{
		{	
			Entity.moveAuto,
			Entity.updateFireDelta,
			function(self, dt)
				if self.x < 0 or self.x > love.graphics.getWidth() then
					self.dx = -self.dx 
				end
				if self.y < 0 or self.y > love.graphics.getHeight() then
					self.dy = -self.dy
				end
			end
		}
	},
	Entity.batches.YellowBouncer
)

Entity.Constructors.GreenChaser = Entity.newConstructor(
	{'x', 'y', 'target'},
	{
		{loseHealth = Entity.loseHealth},
		{
			orientation = 0,
			health = 1,
			damage = 15,
			points = 25,
			speed = 210
			bulletType = Entity.Constructors.YellowShoot
		}
	},
	{
		{	
			Entity.follow,
		}
	},
	Entity.batches.GreenChaser
)

Entity.Constructors.OctoShot = Entity.newConstructor(
	{'x', 'y', 'target'},
	{
		{loseHealth = Entity.loseHealth, shootStraight = Entity.shootSpray},
		{
			orientation = 0,
			health = 50,
			damage = 25,
			points = 75,
			speed = 100
			fireDelay = 2.5
			bulletType = Entity.Constructors.YellowShoot
		}
	},
	{
		{	
			Entity.follow,
		}
	},
	Entity.batches.OctoShot
)

function demonPigTemplate:shoot()
	local orientation = 0
	if self.shootMode == 'beam' then
		self:shootBeam()
	elseif self.shootMode == 'spray' then
		self:shootSpray()
	end
end

function Monster.DemonPig.new(x, y, target)
	local newDemonPig = Monster.new(x, y, target)
	newDemonPig = table.join(newDemonPig, demonPigTemplate)
	newDemonPig.speed = 50
	newDemonPig.damage = 50
	newDemonPig.points = 500
	newDemonPig.batchPointer = Monster.batches.DemonPig
	newDemonPig.bulletType = Bullet.YellowShoot
	newDemonPig.fireDelay = 1.5
	newDemonPig.health = 250
	newDemonPig.shootSpray = Monster.shootSpray
	newDemonPig.shootBeam = Monster.shootBeam
	return newDemonPig
end
