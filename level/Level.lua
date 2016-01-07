require 'level/Blob'

Level = {}
Level.__index = Level
setmetatable(Level, {
	__call = function (cls, ...)
		return cls.new(...)
	end
})

function Level.new(o)
	o = o or {}
	setmetatable(o, Level)
	setmetatable(o, Blob)
	return o
end
