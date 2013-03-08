Particle = {}
Particle.particles = {}

function Particle.add(particle)
	table.insert(Particle.particles, particle)
end

function Particle.remove(particle)
	Particle.particles[table.index(Particle.particles, particle)] = nil
end

function Particle.draw()
	for _, particle in pairs(Particle.particles) do
		love.graphics.draw(particle)
	end
end

function Particle.update(dt)
	for _, particle in pairs(Particle.particles) do
		particle:update(dt)
	end
end

local particleTemplate = {}

function particleTemplate:update(dt)
	self.duration = self.duration - dt
	if self.duration < 0 then Particle.remove(self) end
end

function Particle.new(x, y, duration, image, buffer)
	local newParticle = love.graphics.newParticleSystem(image, buffer)
	newParticle.x = x
	newParticle.y = y
	newParticle.duration = duration
	return newParticle
end

