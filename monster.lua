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
			Entity.bounce,
			Entity.updateFireDelta,
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
			Entity.autoMove
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
			Entity.autMove
		}
	},
	Entity.batches.OctoShot
)

Entity.Constructors.PigDemon = Entity.newConstructor(
	{'x', 'y', 'target'},
	{
		{loseHealth = Entity.loseHealth},
		{
			orientation = 0,
			health = 50,
			damage = 25,
			points = 75,
			speed = 100
			fireDelay = 2.5
			bulletType = Entity.Constructors.DemonPig
		}
	},
	{
		{	
			Entity.bounce,
			Entity.follow,
			Entity.autoMove
			function(self, dt)
				if self.shootMode ~= 'spray' then
					Entity.shootBeam(self)
					self.shootMode = 'spray'
				elseif self.shootMode == 'beam' then
					Entity.shootBeam(self)
					self.shootMode = 'beam'
				end
			end
		}
	},
	Entity.batches.DemonPig
)

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
