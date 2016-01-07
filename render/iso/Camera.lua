Camera = {}
Camera.__index = Camera
setmetatable(Camera, {
	__call = function (cls, ...)
		return cls.new
	end,
})

function Camera.new(o)
	o = o or {}
	setmetatable(o, self)
	return o
end

function Camera:translateViewToMap(x, y)

end

function Camera

function Camera:draw(blob, x, y)

end
