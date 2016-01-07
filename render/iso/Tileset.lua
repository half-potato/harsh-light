require "love.graphics"
Tileset = {}

function Tileset.new(o)
	o = o or {}
	setmetatable(o, Tileset)
	o.__index = o

	-- Load tileset if the data is there
	if o.prefix and o.suffix then
		if (not o.spriteamt) then
			-- Load all with prefix 
			i = 1
			repeat
				i = i + 1
			until not love.filesystem.exists(o.prefix .. i .. o.suffix)
			o.spriteamt = i
		end

		-- Load the files into this table as an array of sprites
		for i = 1, o.spriteamt - 1, 1 do
			o[i] = love.graphics.newImage(o.prefix .. i .. o.suffix)
		end
		o.twidth, o.theight = o[1]:getDimensions()
	end
	
	return o
end

