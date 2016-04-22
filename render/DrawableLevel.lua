require 'level/Level'
require 'util/Img'

DrawableLevel = Level:new()
DrawableLevel.__index = DrawableLevel
--[[
setmetatable(DrawableLevel, {
	__call = function(cls, ...)
		return cls.new(...)
	end,
})
]]--

MAX_UNLOADED_CHUNKS = 10

function DrawableLevel:new(o)
	o = o or {}
	--o = Level.new(o)
	setmetatable(o, DrawableLevel)
	self.__index = self
	o.twidth = o.twidth or 62
	o.theight = o.theight or 32
	o.unloadedChunks = 0
	o.greenSB = love.graphics.newSpriteBatch(o.assetPackage:getFile("green/Green.png"), 10000)
	o.tileSB = love.graphics.newSpriteBatch(o.assetPackage:getFile("tile/Tile.png"), 10000)
	o.structSB = love.graphics.newSpriteBatch(o.assetPackage:getFile("struct/Struct.png"), 10000)

	-- Must reload chunks to apply effect to old tiles
	o.scale = o.scale or 1
	o.mode = o.mode or "iso"
	--temp
	--[[
	o.loadedChunks = o.loadedChunks or {}
	o.entityController = o.entityController or EntityController.new{tileSize = o.tileSize or nil}
	o.entityController.map = o
	if not o.seed then
		o.seed = love.math.noise(os.time(), os.time())
	end
	o.existingChunks = o.existingChunks or {}
	o.chunks = o.chunks or {}
	]]
	return o
end

function DrawableLevel:loadChunk(x, y)
	Level.loadChunk(self, x, y)
	-- Add chunk to spriteBatch
	self:addTilesFromChunk(x, y, self.scale, self.mode)
	self:addStructsFromChunk(x, y, self.scale, self.mode)
	self:addGreeneryFromChunk(x, y, self.scale, self.mode)
end

function DrawableLevel:addGreeneryFromChunk(x, y, scale, mode)
	for i, object in pairs(self.chunks[x][y].green) do
		local ax, ay = self:getPosition(object.cx + x*CHUNK_SIZE, object.cy + y*CHUNK_SIZE, scale, mode)
		local index = math.ceil(love.math.noise(ax, ay) * #object.quads)
		local q = object.quads[index]
		--Tiles can have multiple textures
		self.greenSB:add(q, ax, ay)
	end
end

function DrawableLevel:addStructsFromChunk(x, y, scale, mode)
	for i, object in pairs(self.chunks[x][y].struct) do
		local ax, ay = self:getPosition(object.x + x*CHUNK_SIZE, object.y + y*CHUNK_SIZE, scale, mode)
		local index = math.ceil(love.math.noise(ax, ay) * #object.quads)
		local q = object.quads[index]
		--Tiles can have multiple textures
		self.structSB:add(q, ax, ay)
	end
end

function DrawableLevel:addTilesFromChunk(x, y, scale, mode)
	for tx=1, CHUNK_SIZE do
		for ty=1, CHUNK_SIZE do
			local fixx = 0
			local fixy = 0
			if mode == "iso" then
				fixx = 1
				fixy = 1
			elseif mode == "flat" then
				fixy = 1
			else
				fixy = 1
			end
			local ax, ay = self:getPosition(x*CHUNK_SIZE + tx+fixx, y*CHUNK_SIZE + ty+fixy, scale, mode)
			local q = {}
			local d = self.chunks[x][y].tiles[tx][ty]
			if type(d) == type(1) then
				--Tiles can have multiple textures
				local index = math.ceil(love.math.noise(ax, ay) * #TILE_INDEX[d].quads)
				q = TILE_INDEX[d].quads[index]
			end
			self.tileSB:add(q, ax, ay)
		end
	end
end

function DrawableLevel:unloadChunk(x, y)
	Level.unloadChunk(self, x, y)
	-- Remove the chunk from loaded chunks
	for i, val in pairs(self.loadedChunks) do
		if val.x == x and val.y == y then
			table.remove(self.loadedChunks, i)
		end
	end
	-- When this reaches a certain number, reload the chunks
	self.unloadedChunks = self.unloadedChunks + 1
	if self.unloadedChunks >= MAX_UNLOADED_CHUNKS then
		self:reloadChunks()
	end
end

function DrawableLevel:reloadChunks()
	-- clear all spritebatches
	self.greenSB:clear()
	self.tileSB:clear()
	self.structSB:clear()
	-- Redraw
	for i, val in pairs(self.loadedChunks) do
		self:loadChunk(val.x, val.y)
	end
end

-- mode = "flat", "isozig", "iso"
function DrawableLevel:getPosition(tx, ty, scale, mode)
	--Even or odd row? For zigzag isometric view
	local ax = tx * self.twidth * scale
	local ay = ty * self.theight * scale
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
	return cases[mode].x, cases[mode].y
end

function DrawableLevel:drawEntities(ox, oy)
	for i, entities in pairs(self.entityController.entities) do
		for i=1, #entities do
			local en = entities[i]
			local tx, ty = en.x/(self.entityController.tileSize or 1)+1, en.y/(self.entityController.tileSize or 1) +1 
			local ax, ay = self:getPosition(tx, ty, self.scale, self.mode)
			local quad, texture = en:getCurrentImg()
			love.graphics.draw(texture, quad, ax+ox, ay+oy, 0, self.scale, self.scale)
		end
	end
end

function DrawableLevel:drawMap(ox, oy)
	love.graphics.draw(self.tileSB, ox, oy)
	love.graphics.draw(self.greenSB, ox, oy)
	love.graphics.draw(self.structSB, ox, oy)
end
