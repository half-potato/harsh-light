Level = {}
Level.__index = Level
setmetatable(Level, {
	__call = function(cls, ...)
		return cls.new(...)
	end,
})

function Level.new(o)
	o = o or {
	}

	setmetatable(o, Level)
	return o
end

function Level:setPosition(pos)

end

function Level:renderMap(blob)

end
