EntityController = {}
EntityController.__index = EntityController
setmetatable(EntityController, {
	__call = function (cls, ...)
		return cls.new(...)
	end
})

function EntityController.new(o)
	o = o or {}
	setmetatable(o, EntityController)
	return o
end

function EntityController:update(dt)
end

function EntityController:addEntity(entity, role)
end
