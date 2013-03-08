require 'util'
require 'const'
require 'resource'
require 'entity'
require 'bullet'

Entity.Constructors.BatBouncer = Entity.newConstructor(
	{},
	{'x', 'y', 'target'},
	{
		{loseHealth = Entity.loseHealth},
		{
			dx = math.randsin() / 2,
			dy = math.randsin() / 2,
			orientation = 0,
			health = 50,
			damage = 10,
			points = 50,
			speed = 350,
			type = 'monster'
		}
	},
	{
		{
			Entity.bounce,
			Entity.moveAuto,
			Entity.removeIfDead
		}
	},
	Entity.batches.BatBouncer
)
			

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
			fireDelay = 2, 
			speed = 175,
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
			speed = 200,
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
			speed = 150,
			fireDelay = 2,
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

Entity.Constructors.DemonPig = Entity.newConstructor(
	{},
	{'x', 'y', 'target'},
	{
		{
			loseHealth = Entity.loseHealth,
			fire = function(self, dt)
				if self.shootMode ~= 'spray' then
					Entity.shootBeam(self)
					self.shootMode = 'spray'
				elseif self.shootMode == 'spray' then
					Entity.shootSpray(self)
					self.shootMode = 'beam'
				end
			end,

		},
		{
			dx = math.randsin() / 2,
			dy = math.randsin() / 2,
			orientation = 0,
			health = 50,
			damage = 25,
			points = 75,
			speed = 200,
			fireDelay = 2.5,
			bulletType = Entity.Constructors.YellowShoot,
			type = 'monster'
		}
	},
	{
		{	
			Entity.bounce,
			Entity.moveAuto,
			Entity.removeIfDead,
			Entity.updateFireDelta,
		}
	},
	Entity.batches.DemonPig
)

Entity.Constructors.Coobey = Entity.newConstructor(
	{},
	{'x', 'y', 'target'},
	{
		{
			loseHealth = Entity.loseHealth,
			fire = function(self, dt)
				Entity.Constructors.GreenChaser(self.x, self.y, self.target)
			end
		},
		{
			dx = math.randsin() / 2,
			dy = math.randsin() / 2,
			orientation = 0,
			health = 200,
			damage = 25,
			points = 100,
			speed = 125,
			fireDelay = 2,
			type = 'monster'
		}
	},
	{
		{
			Entity.bounce,
			Entity.moveAuto,
			Entity.removeIfDead,
			Entity.updateFireDelta,
		}
	},
	Entity.batches.Coobey
)

Entity.Constructors.Grizz = Entity.newConstructor(
	{},
	{'x', 'y', 'target'},
	{
		{
			loseHealth = Entity.loseHealth,
			fire = Entity.shootSpray,
		},
		{
			dx = math.randsin() / 2,
			dy = math.randsin() / 2,
			orientation = 0,
			health = 200,
			damage = 50,
			points = 100,
			speed = 100,
			fireDelay = 6,
			bulletType = Entity.Constructors.PurpleBouncer,
			type = 'monster',
		}
	},
	{
		{
			Entity.bounce,
			Entity.moveAuto,
			Entity.removeIfDead,
			Entity.updateFireDelta,
		}
	},
	Entity.batches.Grizz
)
