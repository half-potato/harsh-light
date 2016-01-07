Entity = {}
Entity.__index = Entity
setmetatable(Entity, {
	__call = function (cls, ...)
		return cls.new(...)
	end
})

function Entity.new(o)
	o = o or {}
	setmetatable(o, Entity)
	return o
end
