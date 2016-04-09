require 'util/Noise'
require 'util/Util'
require 'level/biome/Biome'
require 'level/tile/Tile'
require 'level/green/Green'
require 'level/struct/Struct'
require 'level/entity/Entity'

Chunk = {}
Chunk.__index = Chunk
setmetatable(Chunk, {
	__call = function(cls, ...)
		return cls.new(...)
	end,
})

-- either has tiles or seed + x and y
function Chunk.new(o)
	o = o or {}
	setmetatable(o, Chunk)
	if (not o.tiles) then
		if not o.seed then
			o.tiles = {}
			for x = 1, 16 do
				o.tiles[x] = {}
				for y = 1, 16 do
					o.tiles[x][y] = 0
				end
			end
		else
			local s = o.seed / math.pow(10, math.floor(math.log(o.seed, 10)))
			o.biomes = {}
			o.tiles = {}
			o.entities = {}
			o.green = {}
			o.struct = {}
			for x = 1, 16 do
				o.tiles[x] = {}
				o.biomes[x] = {}
				for y = 1, 16 do
					local t = 0.5
					local nbiome = math.pow(love.math.noise(t*(o.x * 16 + x), t*(o.y * 16 + y), 0.30, s*10), 2) * 2
					nbiome = math.min(1, nbiome)
					local ntile = math.pow(love.math.noise(t*(o.x * 16 + x), t*(o.y * 16 + y), 0.15, s*10), 2) * 2
					ntile = math.min(1, ntile)
					local nentity = math.pow(love.math.noise(t*(o.x * 16 + x), t*(o.y * 16 + y), 0.25, s*10), 2) * 2
					nentity = math.min(1, nentity)
					local nstruct = math.pow(love.math.noise(t*(o.x * 16 + x), t*(o.y * 16 + y), 0.75, s*10), 2) * 2
					nstruct = math.min(1, nstruct)
					local ngreen = math.pow(love.math.noise(t*(o.x * 16 + x), t*(o.y * 16 + y), 0.5, s*10), 2) * 2
					ngreen = math.min(1, ngreen)
					local biome, tile, green, entity, struct = o:gen(nbiome, ntile, ngreen, nentity, nstruct)
					o.biomes[x][y] = biome
					o.tiles[x][y] = tile
					if entity then
						o.entities[#o.entities + 1] = deepcopy(ENTITY_INDEX[entity])
						o.entities[#o.entities].pos = {x = x, y = y}
					end
					if green then
						o.green[#o.green + 1] = deepcopy(GREEN_INDEX[green])
						o.green[#o.green].pos = {x = x, y = y}
					end
					if struct then
						o.struct[#o.struct + 1] = deepcopy(STRUCT_INDEX[struct])
						o.struct[#o.struct].pos = {x = x, y = y}
					end
				end
			end
		end
	end
	return o
end

-- returns turple the values biome, tile type, greenery, entity, structure
function Chunk:getData(x, y)
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
		if (self.entities[i].pos.x == x) and (self.entities[i].pos.y == y) then
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

function Chunk:gen(biome, tile, green, entity, struct)
	b = self:genBiome(biome)
	t = self:genTile(tile, b)
	g = self:genGreenery(green, b, t)
	s = self:genStructure(struct, b, t, g)
	e = self:genEntity(entity, b, t, s)
	return b, t, g, e, s
end
