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

function Camera:getImagesAt(blob, x, y)
	biomen, tilen, greenn, entityn, structn = blob:getData(x, y)

-- Mode: 1 - top is top right, 2 - top is bot right, 3 - top is bot left, 4 - top is top left
-- X, Y - origin
-- W, H - screen size
-- MX, MY - center tile
function Camera:draw(blob, x, y, w, h, mx, my, mode)
		
end
