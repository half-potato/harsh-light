require 'util/Noise'
require 'util/Util'
require 'level/biome/Biome'
require 'level/tile/Tile'
require 'level/green/Green'
require 'level/struct/Struct'

Chunk = {}
Chunk.__index = Chunk
setmetatable(Chunk, {
	__call = function(cls, ...)
		return cls.new(...)
	end,
})

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
			o.biomes = {}
			o.tiles = {}
			o.entities = {}
			o.green = {}
			o.struct = {}

			for x = 1, 16 do
				o.tiles[x] = {}
				o.biomes[x] = {}
				for y = 1, 16 do
					biome, tile, green, entity, struct = o:gen(o.x + x, o.y + y, o.seed)
					o.biomes[x][y] = biome
					o.tiles[x][y] = tile
					if entity > 0 then
						o.entities[#o.entities + 1] = deepcopy(ENTITY_INDEX[entity])
						o.entities[#o.entities].pos = {x = x, y = y}
					end
					if green > 0 then
						o.green[#o.green + 1] = deepcopy(GREEN_INDEX[green])
						o.green[#o.green].pos = {x = x, y = y}
					end
					if struct > 0 then
						o.struct[#o.green + 1] = deepcopy(STRUCT_INDEX[struct])
						o.struct[#o.struct].pos = {x = x, y = y}
					end
				end
			end
		end
	end
	return o
end
-- Must be called first
function Chunk:genBiome(x, y, seed)
	noise = perlinNoise2D((x + seed) / 10, (y + seed) / 10, 1/4, 3)
	-- range is from 1 - 2
	return math.ceil((#BIOME_INDEX * (noise)) + 0.001)
end

-- Must be called second
function Chunk:genTile(x, y, seed, biome)
	noise = perlinNoise2D(x + seed, y + seed, 1/2, 3)
	print(noise)
	t = noise	
	prob = 0
	for x=1, #BIOME_INDEX do
		l = BIOME_INDEX[biome].tile_index[x]
		if t > prob then
			return l[0]
		end
	end

	return 1
end

-- Rest have no order
function Chunk:genGreenery(x, y, seed, biome, tile)
	noise = perlinNoise2D(x + (seed / 4), y + (seed / 1.2), 1, 3)
	if (math.floor((noise) / BIOME_INDEX[biome].green_density) == 1)
		and (TILE_INDEX[tiles[x][y]].isGrowable) then
		t = noise
		prob = 0
		for x=1, #BIOME_INDEX do
			l = BIOME_INDEX[biome].green_index[x]
			prob = prob + l[1]
			if t > prob then
				return l[0]
			end
		end
			
	end

	return 0
end

function Chunk:genEntity(x, y, seed, biome, tile)
	noise = perlinNoise2D(x + (seed / 3), y + (seed / math.pi / 2), 1, 3)
	if (math.floor((noise) / BIOME_INDEX[biome].entity_density) == 1) 
		and (TILE_INDEX[tiles[x][y]].isSpawnable) then
		t = noise
		prob = 0
		for x=1, #BIOME_INDEX do
			l = BIOME_INDEX[biome].entity_index
			prob = prob + l[1]
			if t > prob then
				return l[0]
			end
		end
	end
	return 0
end

function Chunk:genStructure(x, y, seed, biome, tile)
	noise = perlinNoise2D(x + (seed / math.pi), y + (seed / 3.2), 1, 3)
	if (math.floor((noise - 1) / BIOME_INDEX[biome].struct_density) == 1) then
		prob = 0
		t = noise
		for x=1, #BIOME_INDEX do
			l = BIOME_INDEX[biome].struct_index
			prob = prob + l[1]
			if t > prob then
				return l[0]
			end
		return i
		end
	end
	return 0
end

function Chunk:gen(x, y, seed)
	biome = self:genBiome(x, y, seed)
	tile = self:genTile(x, y, seed, biome)
	green = self:genGreenery(x, y, seed, biome, tile)
	entity = self:genEntity(x, y, seed, biome, tile)
	struct = self:genStructure(x, y, seed, biome, tile)
	return biome, tile, green, entity, struct
end
