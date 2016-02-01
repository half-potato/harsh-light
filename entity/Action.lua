Action = {}
Action.__index = Action
setmetatable(Action, {
	__call = function (cls, ...)
		return cls.new(...)
	end
})

function Action.new(o)
	o = o or {}
	setmetatable(o, Action)
	return o
end
