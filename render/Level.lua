require 'level/Blob'
require 'util/Img'

Level = {}
Level.__index = Level
setmetatable(Level, {
	__call = function (cls, ...)
		return cls.new(...)
	end
})

-- quadmode = "iso" or "flat"
function Level.new(o)
	o = o or {}
	setmetatable(o, Level)
	setmetatable(o, Blob)
	o = Blob.new(o)
	o.twidth = o.twidth or 62
	o.theight = o.theight or 32
	o.meshBase = meshPoints(0, 0, o.twidth, o.theight, quadmode)
	return o
end

function self:genMesh(x, y, scale)
	points = self.meshBase
	for i=1, #points do
		points[i][1] = points[i][1] * scale + x
		points[i][2] = points[i][2] * scale + y
	end
	return love.graphics.newMesh(points, "fan", "static")
end

--chunksToLoad = {{x, y}}. Layer = "biomes", "tiles", "entities", "green", or "struct"
function Level:spriteBatch(chunksToLoad, tilesheet, layer)
	local minX, local minY = chunksToLoad[1][1], chunksToLoad[1][2]
	local maxX, local maxY = chunksToLoad[1][1], chunksToLoad[1][2]
	for i=1, #chunksToLoad do
		if minX > chunksToLoad[i][1] then
			minX = chunksToLoad[i][1]
		end
		if minY > chunksToLoad[i][2] then
			minY = chunksToLoad[i][2]
		end
		if maxX < chunksToLoad[i][1] then
			maxX = chunksToLoad[i][1]
		end
		if maxY < chunksToLoad[i][2] then
			maxY = chunksToLoad[i][2]
		end
	end
	-- Create spritebatch
	local spriteBatch = love.graphics.newSpriteBatch(tilesheet, (maxX - minX) * (maxY - minY) * 256, "static")
	
	for i=1, #chunksToLoad do
		local c = self.chunks[chunksToLoad[i][1]][chunksToLoad[i][2]]
		if not c then
			self:genChunk(chunksToLoad[i][1],chunksToLoad[i][2])
		end
		for ix=1, #c do
			for iy=1, #c[i] do
				local x = (ix-1) * self.twidth * scale + minX * 16 * self.twidth * scale
				local y = (iy-1) * self.theight * scale + minY * 16 * self.theight * scale
				local m = self:genMesh(x, y, scale)
				local d = self.chunks[chunksToLoad[i][1]][chunksToLoad[i][2]][layer][ix][iy]
				if not d.name then
					ax = chunksToLoad[i][1] * 16 + ix
					ay = chunksToLoad[i][2] * 16 + iy
					index = love.math.noise(ax, ay) * #TILE_INDEX[d].quads + 1
					m:attachAttribute("texture", TILE_INDEX[d].quads[index])
				else
					ax = chunksToLoad[i][1] * 16 + ix
					ay = chunksToLoad[i][2] * 16 + iy
					index = love.math.noise(ax, ay) * #d.quads + 1
					m:attachAttribute("texture", d.quads[index])
				end
				spriteBatch:attachAttribute(ax .. "," .. ay, m)
			end
		end
	end
	return spriteBatch
end
