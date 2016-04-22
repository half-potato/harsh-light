require 'util/Util'
require 'level/biome/Biome'
require 'level/tile/Tile'
require 'level/green/Green'
require 'level/struct/Struct'
require 'entity/EntityTable'

CHUNK_SIZE = 16

Chunk = {}
--[[
Chunk.__index = Chunk
setmetatable(Chunk, {
	__call = function(cls, ...)
		return cls.new(...)
	end,
})]]

-- either has tiles or seed + x and y
function Chunk:new(o)
	o = o or {}
	setmetatable(o, Chunk)
	self.__index = self
	if (not o.tiles) then
		if not o.seed then
			o.tiles = {}
			for x = 1, CHUNK_SIZE do
				o.tiles[x] = {}
				for y = 1, CHUNK_SIZE do
					o.tiles[x][y] = 0
				end
			end
		else
			o:generate()
		end
	end
	return o
end

-- returns turple the values biome, tile type, greenery, entity, structure
function Chunk:getData(x, y)
	if self.biomes[x] then
		if self.biomes[x][y] then
			b = self.biomes[x][y]
			t = self.tiles[x][y]
			g = 0
			for i=1, #self.green do
				if (self.green[i].pos.x == x) and (self.green[i].pos.y == y) then
					g = self.green[i]
				end
			end
			e = 0
			for i=1, #self.entities do
				if (self.entities[i].pos.cx == x) and (self.entities[i].pos.cy == y) then
					e = self.entities[i]
				end
			end
			s = 0
			for i=1, #self.struct do
				if (self.struct[i].pos.x == x) and (self.struct[i].pos.y == y) then
					g = self.struct[i]
				end
			end
			return b, t, g, e, s
		end
	end
	return nil
end

function Chunk:genBiome(v)
	local prob = 0
	for x=1, #BIOME_PROB do
		local l = BIOME_PROB[x]
		prob = prob + l[2]
		if v <= prob then
			return l[1]
		end
	end

	return nil
end

-- Must be called second
function Chunk:genTile(v, biome)
	local prob = 0
	for x=1, #(BIOME_INDEX[biome].tile_index) do
		local l = BIOME_INDEX[biome].tile_index[x]
		prob = prob + l[2]
		if v <= prob then
			return l[1]
		end
	end

	return nil
end

-- Rest have no order
function Chunk:genGreenery(v, biome, tile)
	if (v < BIOME_INDEX[biome].green_density) and TILE_INDEX[tile].isGrowable then
		local prob = 0
		for x=1, #(BIOME_INDEX[biome].green_index)do
			local l = BIOME_INDEX[biome].green_index[x]
			prob = prob + l[2]
			if v <= prob then
				return l[1]
			end
		end
	else
		return nil
	end
end

function Chunk:genEntity(v, biome, tile, struct)
	if (v < BIOME_INDEX[biome].entity_density) and TILE_INDEX[tile].isSpawnable and (not struct) then
		local prob = 0
		for x=1, #(BIOME_INDEX[biome].entity_index)do
			local l = BIOME_INDEX[biome].entity_index[x]
			prob = prob + l[2]
			if v <= prob then
				return l[1]
			end
		end
	end
	return nil
end

function Chunk:genStructure(v, biome, tile, green)
	if (v < BIOME_INDEX[biome].struct_density) and not green then
		local prob = 0
		for x=1, #(BIOME_INDEX[biome].struct_index)do
			local l = BIOME_INDEX[biome].struct_index[x]
			prob = prob + l[2]
			if v <= prob then
				return l[1]
			end
		return i
		end
	end
	return nil
end

function Chunk:genSingle(biome, tile, green, entity, struct)
	b = self:genBiome(biome)
	t = self:genTile(tile, b)
	g = self:genGreenery(green, b, t)
	s = self:genStructure(struct, b, t, g)
	e = self:genEntity(entity, b, t, s)
	return b, t, g, e, s
end

function Chunk.noiseFn(x, y, n, s)
	return math.min(1, math.pow(love.math.noise(0.5*x, 0.5*y, n, s*10), 2) * 2)
end

function Chunk:generate()
	local s = self.seed / math.pow(10, math.floor(math.log(self.seed, 10)))
	self.biomes = {}
	self.tiles = {}
	self.entities = {}
	self.green = {}
	self.struct = {}
	for x = 1, CHUNK_SIZE do
		self.tiles[x] = {}
		self.biomes[x] = {}
		for y = 1, CHUNK_SIZE do
			local ax = (self.x * CHUNK_SIZE + x)
			local ay = (self.y * CHUNK_SIZE + y)
			local nbiome = Chunk.noiseFn(ax, ay, 0.01, s)
			local ntile = Chunk.noiseFn(ax, ay, 0.15, s)
			local nentity = Chunk.noiseFn(ax, ay, 0.25, s)
			local nstruct = Chunk.noiseFn(ax, ay, 0.75, s)
			local ngreen = Chunk.noiseFn(ax, ay, 0.50, s)
			local biome, tile, green, entity, struct = self:genSingle(nbiome, ntile, ngreen, nentity, nstruct)
			self.biomes[x][y] = biome
			self.tiles[x][y] = tile
			if entity then
				self.entities[#self.entities + 1] = deepcopy(ENTITY_INDEX[entity])
				self.entities[#self.entities].cx = x
				self.entities[#self.entities].cy = y
			end
			if green then
				self.green[#self.green + 1] = deepcopy(GREEN_INDEX[green])
				self.green[#self.green].cx = x
				self.green[#self.green].cy = y
			end
			if struct then
				self.struct[#self.struct + 1] = deepcopy(STRUCT_INDEX[struct])
				self.struct[#self.struct].cx = x
				self.struct[#self.struct].cy = y
			end
		end
	end
end
