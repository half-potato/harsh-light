require "love.graphics"
Tileset = {}

function Tileset.new(o)
	o = o or {}
	setmetatable(o, Tileset)
	o.__index = o

	-- Load tileset if the data is there
	
	if(o.twidth and o.theight and o.tsetname) then
		o.tset = love.graphics.newImage(o.tsetname)
		local iw, ih = o.tset:getDimensions()
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

