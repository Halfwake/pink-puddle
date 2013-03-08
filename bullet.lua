require 'util'
require 'entity'
require 'const'
require 'resource'


Entity.Constructors.IceBall = Entity.newConstructor(
	{},
	{'x', 'y', 'dx', 'dy', 'orientation', 'target', 'friendly'},
	{
		{inBounds = Entity.inBounds, isEnemy = Entity.isEnemy},
		{speed = 350, damage = 15, health = 1, type = 'bullet', invuln = true}
	},
	{
		{Entity.moveAuto, Entity.addBatch, Entity.removeOffScreen, Entity.removeIfOutOfBounds}
	},
	Entity.batches.IceBall
)

Entity.Constructors.YellowShoot = Entity.newConstructor(
	{},
	{'x', 'y', 'dx', 'dy', 'orientation', 'target', 'friendly'},
	{
		{inBounds = Entity.inBounds, isEnemy = Entity.isEnemy},
		{speed = 150, damage = 15, health = 1, type = 'bullet', invuln = true}
	},
	{
		{Entity.moveAuto, Entity.addBatch, Entity.removeOffScreen, Entity.removeIfOutOfBounds}
	},
	Entity.batches.YellowShoot
)

Entity.Constructors.PurpleBouncer = Entity.newConstructor(
	{},
	{'x', 'y', 'dx', 'dy', 'orientation', 'target', 'friendly'},
	{
		{inBounds = Entity.inBounds, isEnemy = Entity.isEnemy},
		{speed = 100, damage = 15, health = 1, type = 'bullet', invuln = true, duration =  5}
	},
	{
		{
			Entity.moveAuto,
			Entity.bounce,
			Entity.addBatch,
			Entity.removeOffScreen,
			function(self, dt)
				self.duration = self.duration - dt
				if self.duration <= 0 then Entity.remove(self) end
			end
		}
	},
	Entity.batches.PurpleBouncer
)
