require "love.graphics"
Tilemap = {}
Tilemap.__index = Tilemap

setmetatable(Tilemap, {
	__call = function(cls, ...)
		return cls.new(...)
	end,
})

function Tilemap.new(o)
	o = o or {}
	setmetatable(o, Tilemap)
	o.__index = o

	-- Load tileset if the data is there
	
	if(o.twidth and o.theight and o.tmapname) then
		o.tmap = love.graphics.newImage(o.tmapname)
		local iw, ih = o.tmap:getDimensions()
		o.width = math.floor(iw / o.twidth)
		o.height = math.floor(ih / o.theight)
		for i = 0, o.width * o.height - 1, 1 do
			local tx = (i - (o.width * math.floor(i / o.width))) * o.twidth
			local ty = math.floor(i / o.width) * o.theight
			o[i + 1] = love.graphics.newQuad(tx, ty, o.twidth, o.theight, iw, ih)
		end
	end
	return o
end

function Tilemap:getWidth()
	return self.tmap:getWidth()
end

function Tilemap:getHeight()
	return self.tmap:getHeight()
end

function Tilemap:getCoords(i)
	tx = (i - (self.width * math.floor(i / self.width)))
	ty = math.floor(i / self.width)

	return tx, ty
end

function Tilemap:getBotUV(i)
	x, y = self:getCoords(i)
	--tx = self.width - x
	ux = x / self.width
	uv = y / self.height

	return ux, uv
end

function Tilemap:getUVDimensions()
	return self.twidth / self.tmap:getWidth(), self.theight / self.tmap:getHeight()
end
