require 'util'
require 'entity'
require 'const'
require 'resource'


Entity.Constructors.IceBall = Entity.newConstructor(
	{},
	{'x', 'y', 'dx', 'dy', 'orientation', 'target', 'friendly'},
	{
		{inBounds = Entity.inBounds, isEnemy = Entity.isEnemy},
		{speed = 250, damage = 10}
	},
	{
		{Entity.moveAuto, Entity.addBatch}
	},
	Entity.batches.IceBall
)

Entity.Constructors.YellowShoot = Entity.newConstructor(
	{},
	{'x', 'y', 'dx', 'dy', 'orientation', 'target', 'friendly'},
	{
		{inBounds = Entity.inBounds, isEnemy = Entity.isEnemy},
		{speed = 350, damage = 15}
	},
	{
		{Entity.moveAuto, Entity.addBatch}
	},
	Entity.batches.YellowShoot
)
