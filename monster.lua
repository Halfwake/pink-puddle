require 'util'
require 'const'
require 'resource'
require 'entity'
require 'bullet'


Entity.Constructors.YellowBouncer = Entity.newConstructor(
	{},
	{'x', 'y', 'target'},
	{
		{loseHealth = Entity.loseHealth, fire = Entity.shootStraight},
		{
			dx = math.randsin() / 2,
			dy = math.randsin() / 2,
			orientation = 0,
			health = 25,
			damage = 50,
			points = 50,
			fireDelay = 3, 
			speed = 150,
			bulletType = Entity.Constructors.YellowShoot,
			type = 'monster'
		}
	},
	{
		{	
			Entity.bounce,
			Entity.moveAuto,
			Entity.updateFireDelta,
			Entity.removeIfDead
		}
	},
	Entity.batches.YellowBouncer
)

Entity.Constructors.GreenChaser = Entity.newConstructor(
	{},
	{'x', 'y', 'target'},
	{
		{loseHealth = Entity.loseHealth},
		{
			orientation = 0,
			health = 1,
			damage = 15,
			points = 25,
			speed = 50,
			bulletType = Entity.Constructors.YellowShoot,
			type = 'monster'
		}
	},
	{
		{	
			Entity.follow,
			Entity.moveAuto,
			Entity.removeIfDead
		}
	},
	Entity.batches.GreenChaser
)

Entity.Constructors.OctoShot = Entity.newConstructor(
	{},
	{'x', 'y', 'target'},
	{
		{loseHealth = Entity.loseHealth, fire = Entity.shootSpray},
		{
			orientation = 0,
			health = 50,
			damage = 25,
			points = 75,
			speed = 100,
			fireDelay = 2.5,
			bulletType = Entity.Constructors.YellowShoot,
			type = 'monster'
		}
	},
	{
		{	
			Entity.follow,
			Entity.moveAuto,
			Entity.updateFireDelta,
			Entity.removeIfDead
		}
	},
	Entity.batches.OctoShot
)

Entity.Constructors.PigDemon = Entity.newConstructor(
	{},
	{'x', 'y', 'target'},
	{
		{loseHealth = Entity.loseHealth},
		{
			orientation = 0,
			health = 50,
			damage = 25,
			points = 75,
			speed = 100,
			fireDelay = 2.5,
			bulletType = Entity.Constructors.DemonPig,
			type = 'monster'
		}
	},
	{
		{	
			Entity.bounce,
			Entity.moveAuto,
			Entity.removeIfDead,
			Entity.updateFireDelta,
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
