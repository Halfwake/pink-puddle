require 'util'
require 'entity'
require 'const'
require 'resource'


Entity.Constructors.IceBall = Entity.newConstructor(
	{},
	{'x', 'y', 'dx', 'dy', 'orientation', 'target', 'friendly'},
	{
		{inBounds = Entity.inBounds, isEnemy = Entity.isEnemy},
		{speed = 250, damage = 15, health = 1, type = 'bullet', invuln = true}
	},
	{
		{Entity.moveAuto, Entity.addBatch, Entity.removeOffScreen, Entity.removeIfDead}
	},
	Entity.batches.IceBall
)

Entity.Constructors.YellowShoot = Entity.newConstructor(
	{},
	{'x', 'y', 'dx', 'dy', 'orientation', 'target', 'friendly'},
	{
		{inBounds = Entity.inBounds, isEnemy = Entity.isEnemy},
		{speed = 75, damage = 15, health = 1, type = 'bullet', invuln = true}
	},
	{
		{Entity.moveAuto, Entity.addBatch, Entity.removeOffScreen, Entity.removeIfDead}
	},
	Entity.batches.YellowShoot
)
