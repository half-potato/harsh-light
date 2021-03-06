require 'level/Blob'
require 'util/Img'

DrawableBlob = {}
DrawableBlob.__index = DrawableBlob
setmetatable(DrawableBlob, {
	__call = function (cls, ...)
		return cls.new(...)
	end
})

-- quadmode = "iso" or "flat"
function DrawableBlob.new(o)
	o = o or {}
	if not o.chunks then
		o = Blob.new(o)
	end
	setmetatable(o, DrawableBlob)
	o.twidth = o.twidth or 62
	o.theight = o.theight or 32
	o.meshBase = meshPoints(0, 0, o.twidth, o.theight, o.quadmode)
	return o
end

function DrawableBlob:drawEntity(entity, x, y, scale)
	local quad, texture = entity:getCurrentImg()
	love.graphics.draw(texture, quad, x, y, 0, scale, scale)
end

function DrawableBlob:drawEntities(chunksToLoad, scale, mode, ox, oy)
	entities = {}
	for i=1, #chunksToLoad do
		local cx, cy = chunksToLoad[i][1], chunksToLoad[i][2]
		for x=1, #self.chunks[cx][cy][layer] do
			entities[#entities+1] = {self.chunks[cx][cy][layer][x], cx, cy}
		end
	end
	if #entities > 0 then
		for i=1, #entities do
			--If chunk does not exist, generate it
			cx, cy = entities[i][2], entities[i][3]
			local c = self.chunks[cx][cy]
			if not c then
				self:genChunk(cx, cy)
				c = self.chunks[cx][cy]
			end
			local entity = entities[i][1]
			-- Position in chunk + chunk position in map = flat position
			--Tile position
			local tx, ty = cx*16 + entity.pos.x, cy*16 + entity.pos.y
			--Screen position
			local ax = tx * self.twidth * scale
			local ay = ty * self.theight * scale
			--Even or odd row? For zigzag isometric view
			local o = ty % 2
			local cases = {
				flat = {
					x = ax,
					y = ay},
				isozig = {
					-- figure out if even or odd row
					x = ax + ((o * self.twidth * scale) / 2),
					-- also offset for building up decreas
					y = ay - ((o * self.theight * scale) / 2) 
					- ((math.floor(ty/2)+1) * self.theight)
					},
				iso = {
					x = (tx-ty) * (self.twidth/2),
					y = (ty+tx) * (self.theight/2)}
			}
			--Translate that position to create positions for the sprites
			local x = cases[mode].x + ox
			local y = cases[mode].y + oy
			self:drawEntity(entity, x, y, scale)
		end
	end
end

-- Layer can be "green" or "struct"
function DrawableBlob:objectSpriteBatch(chunksToLoad, tilesheet, scale, mode, layer)
	scale = scale or 1
	-- Create spritebatch
	-- Size depends on the amount of objects in the array
	objects = {}
	for i=1, #chunksToLoad do
		local cx, cy = chunksToLoad[i][1], chunksToLoad[i][2]
		for x=1, #self.chunks[cx][cy][layer] do
			objects[#objects+1] = {self.chunks[cx][cy][layer][x], cx, cy}
		end
	end
	-- TODO: ADD SORTING METHOD TO RENDER OBJECTS CLOSER LAST
	if #objects > 0 then
		local spriteBatch = love.graphics.newSpriteBatch(tilesheet, #objects, "static")

		for i=1, #objects do
			--If chunk does not exist, generate it
			cx, cy = objects[i][2], objects[i][3]
			local c = self.chunks[cx][cy]
			if not c then
				self:genChunk(cx, cy)
				c = self.chunks[cx][cy]
			end
			local object = objects[i][1]
			-- Position in chunk + chunk position in map = flat position
			--Tile position
			local tx, ty = cx*16 + object.pos.x, cy*16 + object.pos.y
			--Screen position
			local ax = tx * self.twidth * scale
			local ay = ty * self.theight * scale
			--Even or odd row? For zigzag isometric view
			local o = ty % 2
			local cases = {
				flat = {
					x = ax,
					y = ay},
				isozig = {
					-- figure out if even or odd row
					x = ax + ((o * self.twidth * scale) / 2),
					-- also offset for building up decreas
					y = ay - ((o * self.theight * scale) / 2) 
					- ((math.floor(ty/2)+1) * self.theight)
					},
				iso = {
					x = (tx-ty) * (self.twidth/2),
					y = (ty+tx) * (self.theight/2)}
			}
			--Translate that position to create positions for the sprites
			local x = cases[mode].x
			local y = cases[mode].y
			--Get texture
			--q = quad in texture map, d = thing being rendered
			local index = math.ceil(love.math.noise(ax, ay) * #object.quads)
			local q = object.quads[index]
			--Tiles can have multiple textures
			spriteBatch:add(q, x, y)
		end
		return spriteBatch
	else
		return nil
	end
end
--chunksToLoad = {{x, y}} 
-- Mode = placement mode. Can be iso, isozig, flat
function DrawableBlob:tileSpriteBatch(chunksToLoad, tilesheet, scale, mode)
	scale = scale or 1
	--Calculate min and max to determine the size of the sprite batch
	local minX = chunksToLoad[1][1] 
	local minY = chunksToLoad[1][2]
	local maxX = chunksToLoad[1][1] 
	local maxY = chunksToLoad[1][2]
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
	local spriteBatch = love.graphics.newSpriteBatch(tilesheet, (maxX - minX + 1) * (maxY - minY + 1) * 256, "static")
	
	for i=1, #chunksToLoad do
		--If chunk does not exist, generate it
		cx, cy = chunksToLoad[i][1], chunksToLoad[i][2]
		local c = self.chunks[cx][cy]
		if not c then
			self:genChunk(cx, cy)
			c = self.chunks[cx][cy]
		end
		for ix=1, #c.tiles do
			for iy=1, #c.tiles[ix] do
				-- Position in chunk + chunk position in map = flat position
				--Tile position
				local tx = cx*16 + ix
				local ty = cy*16 + iy
				--Screen position
				local ax = tx * self.twidth
				local ay = ty * self.theight
				--Even or odd row? For zigzag isometric view
				local o = iy % 2
				local cases = {
					flat = {
						x = ax,
						y = ay},
					isozig = {
						-- figure out if even or odd row
						x = ax + ((o * self.twidth * scale) / 2),
						-- also offset for building up decreas
						y = ay - ((o * self.theight * scale) / 2) 
						- (math.floor(ty/2) * self.theight)
						},
					iso = {
						x = (tx-ty) * (self.twidth/2),
						y = (ty+tx) * (self.theight/2)}
				}
				--Translate that position to create positions for the sprites
				local x = cases[mode].x
				local y = cases[mode].y
				--Get texture
				--q = quad in texture map, d = thing being rendered
				local q = {}
				local d = self.chunks[cx][cy].tiles[ix][iy]
				if type(d) == type(1) then
					--Tiles can have multiple textures
					local index = math.ceil(love.math.noise(ax, ay) * #TILE_INDEX[d].quads)
					q = TILE_INDEX[d].quads[index]
				else
					--Things can have multiple textures
					local index = love.math.noise(ax, ay) * #d.quads + 1
					q = d.quads[index]
				end
				spriteBatch:add(q, x, y)
			end
		end
	end
	return spriteBatch
end

function DrawableBlob:draw(chunksToLoad, scale, mode, ox, oy)
	self:drawEntities (chunksToLoad, scale, mode, ox, oy)
	tmap = map:tileSpriteBatch(chunksToLoad, gAssetPackage.tile["Tile.png"], scale, mode)
	gmap = map:objectSpriteBatch(chunksToLoad, gAssetPackage.green["Green.png"], scale, mode, "green")
	smap = map:objectSpriteBatch(chunksToLoad, gAssetPackage.struct["Struct.png"], scale, mode, "struct")
end
