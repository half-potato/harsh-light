require 'level/Tile'
Map = {}
Map.__index = Map

setmetatable(Map, {
	__call = function(cls, ...)
		return cls.new(...)
	end,
})

function Map.new(o)
	o = o or {}
	setmetatable(o, Map)
	o.__index = o
	
	o.angle = 0

	if (not o.data) and o.mapname then
		o:loadMap(o.mapname)
	end

	if (o.tilemap.tmap and o.data) then
		print("Map has been init")
		o:updateMesh()
		rotPX = 0
		rotPY = 0
	end

	return o
end

-- Use toIso(x, y) for getting coords

function Map:loadMap(name)
	self.mapname = name
	-- Todo: Add loader
end

function Map:updateMesh()
	points = rotatedIsoPoints(self.angle, self.tileset.twidth, self.tileset.theight)
	self.tmesh = love.graphics.newMesh(points, self.tilemap.tmap)
end

-- Input map coords and get the mesh for the tile
function Map:getMesh(x, y)
	tid = self.data[x][y]
	-- If the current tile id is not the one to draw, set it
	if self.curtid ~= tid then
		self.curtid = tid

		-- Set the texture coords to the tile coords
		udx, udy = self.tilemap:getUVDimensions()
		ux, uy = self.tilemap:getBotUV(self.curtid)

		mpoints = self.tmesh:getVertices()
		-- Top Left
		mpoints[1][3] = ux
		mpoints[1][4] = uy + udy
		-- Top Right
		mpoints[2][3] = ux + udx
		mpoints[2][4] = uy + udy
		-- Bot Left
		mpoints[3][3] = ux
		mpoints[3][4] = uy
		-- Bot Right
		mpoints[4][3] = ux + udx
		mpoints[4][4] = uy
		
		self.tmesh:setVertices(mpoints)
	end

	return self.tmesh
end

function Map:setAngle(n)
	self.angle = n
	self:updateMesh()
end

function Map:draw(originx, originy, midx, midy)
	for x, row in next, self.data, nil do
		for y, tid in next, row, nil do
			m = self:getMesh(x, y)
			angle = math.pi / 4
			w, h = self.tileset.twidth, self.tileset.theight
			cx, cy = rotate(angle, x * w, y * h)
			cy = cy / 2

			-- Rotate it
			midheight = cy - midy
			midwidth = cx - midx
			tangle = math.atan(midheight / midwidth) + (self.angle * (2 * math.pi / 360))
			offx, offy = math.cos(tangle) * midwidth, math.sin(tangle) * midheight

			offy = offy / 2

			love.graphics.draw(m, cx + originx + offx, cy + originy + offy)
		end
	end
end
