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
	o.zoom = 1

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
	points = rotatedIsoPoints(self.angle, self.tileset.twidth * self.zoom, self.tileset.theight * self.zoom)
	self.tmesh = love.graphics.newMesh(points, self.tilemap.tmap)
end

-- Percentage of width, 0 - 1
function Map:setAnchor(x, y)
	self.anchorx = x
	self.anchory = y
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
		singlepixel = (1 / self.tilemap:getWidth())

		mpoints = self.tmesh:getVertices()
		-- Bot Left
		mpoints[1][3] = ux
		mpoints[1][4] = uy
		-- Top Left
		mpoints[2][3] = ux
		mpoints[2][4] = uy + udy
		-- Top Right
		mpoints[3][3] = ux + udx - singlepixel
		mpoints[3][4] = uy + udy
		-- Bot Right
		mpoints[4][3] = ux + udx - singlepixel
		mpoints[4][4] = uy
		
		self.tmesh:setVertices(mpoints)
	end

	return self.tmesh
end

function Map:getWidth()
	nonsqrtleng = 0
	for x, row in next, self.data, nil do
		dist = table.getn(row) * self.tileset.theight * self.zoom
		r = x * self.tileset.twidth * self.zoom
		l = dist * dist + r * r
		if(nonsqrtleng < l) then
			nonsqrtleng = l
		end
	end
	return math.sqrt(nonsqrtleng)
end

function Map:getHeight()
	both = table.getn(self.data[1])
	-- Lazy, only checks the first row
	toph = table.getn(self.data)

	theight = (both + toph)

	height = (theight * self.tileset.theight * self.zoom) / 2 - 128

	return height
end

-- Mode = which part of the tile. 1 = top, 2 = right, 3 = bot, 4 = left, 5 = mid
function Map:getPos(tx, ty, mode)
	x = tx * self.tileset.twidth
	y = ty * self.tileset.theight / 2
	-- This is the bottom of the tile
	if mode == 1 then
		y = y - self.tileset.theight / 2
	elseif mode == 2 then
		y = y - self.tileset.theight / 4
		x = x + self.tileset.twidth / 4
	elseif mode == 4 then
		y = y - self.tileset.theight / 4
		x = x - self.tileset.twidth / 4
	elseif mode == 5 then
		y = y - self.tileset.theight / 4
	end

	love.graphics.point(x, y)
	return x, y
end

function Map:draw(originx, originy, midx, midy, angle, zoom)
	for x, row in next, self.data, nil do
		for y, tid in next, row, nil do
			-- Try not to update the mesh twice
			if not (zoom == self.zoom) then
				self.zoom = zoom
				if not (angle == self.angle) then
					self.angle = angle
					self:updateMesh()
				else
					self:updateMesh()
				end
			elseif not (angle == self.angle) then
				self.angle = angle
				self:updateMesh()
			end

			w, h = self.tileset.twidth, self.tileset.theight

			-- Rotate by 45 degrees
			fourfive = math.pi / -4
			cx, cy = rotate(fourfive, x * w * zoom, y * h * zoom)

			cx = cx + originx
			cy = cy + originy

			-- Rotate it by the degree specified around the center point
			midheight = cy - midx
			midwidth = cx - midy

			-- Find current angle around center point
			curtangle = math.atan(midheight / midwidth)
			
			-- Compensate for tangent range
			if not (isPositive(midwidth)) then
				 curtangle = curtangle + math.pi
			end

			rottangle = (self.angle * (2 * math.pi / 360))
			tangle = curtangle + rottangle

			-- Offx, offy creates a vector of length 1
			offx, offy = math.cos(tangle), math.sin(tangle)

			-- Scale that vector to the original length
			orileng = math.sqrt(midheight * midheight + midwidth * midwidth)
			offx = offx * orileng
			offy = offy * orileng

			offy = offy / 2
			cy = cy / 2

			-- Offset anchor
			aoffx = 1 * self:getWidth() * self.anchorx
			aoffy = 1 * self:getHeight() * (self.anchory - 0)
			love.graphics.point(-aoffx, aoffy)

			m = self:getMesh(x, y)
			love.graphics.draw(m, offx + midx + aoffx, offy + midx + aoffy)
		end
	end
end

function isPositive(n)
	return (n / math.abs(n)) == 1
end
