Object = {}
Object.__index = Object
setmetatable(Object, {
	__call = function(cls, ...)
		return cls.new(...)
	end,
})

function Object.new(o)
	o = o or {
		-- XY are relative to tiles and can be floats
		x = 0,
		y = 0,
		image = love.graphics.newImage("../assets/CGrid.png"),
		-- WH are in tile size
		w = 1,
		h = 1
	}

	setmetatable(o, Object)
	return o
end
