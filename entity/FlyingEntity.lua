require 'entity/Entity'

FlyingEntity = Entity:new()
--[[
FlyingEntity.__index = FlyingEntity
setmetatable(FlyingEntity, {
	__index = Entity,
	__call = function (cls, ...)
		return cls.new(...)
	end
})]]

function FlyingEntity:new(o)
	o = o or {}
	--o = Entity.new(o)
	setmetatable(o, FlyingEntity)
	self.__index = self
	return o
end

function FlyingEntity:updateVelocity(dt)
	self.velocity = {x=math.cos(self.timer / 0.5)*0.1, y=math.tan(self.timer / 0.5)*0.1}
	--self.velocity = {x=0.5, y=0.5}
	--print_r(self.velocity)
end
