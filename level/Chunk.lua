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
			love.math.setRandomSeed(o.seed)
			o.biomes = {}
			o.tiles = {}
			o.entities = {}
			o.green = {}
			o.struct = {}

			nbiome = genMap(16, 16, #BIOME_INDEX, 16)
			ntile = genMap(16, 16, 1, 30)
			ngreen = genMap(16, 16, 1, 1000)
			nentity = genMap(16, 16, 1, 1000)
			nstruct = genMap(16, 16, 1, 1000)

			for x = 1, 16 do
				o.tiles[x] = {}
				o.biomes[x] = {}
				for y = 1, 16 do
					biome, tile, green, entity, struct = o:gen(math.ceil(nbiome[x][y]) - 1, ntile[x][y], ngreen[x][y], nentity[x][y], nstruct[x][y])
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
						o.struct[#o.struct + 1] = deepcopy(STRUCT_INDEX[struct])
						o.struct[#o.struct].pos = {x = x, y = y}
					end
				end
			end
		end
	end
	return o
end

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

-- Must be called second
function Chunk:genTile(val, biome)
	t = val	
	prob = 0
	for x=1, #(BIOME_INDEX[biome].tile_index) do
		l = BIOME_INDEX[biome].tile_index[x]
		if t > prob then
			return l[x]
		end
	end

	return 1
end

-- Rest have no order
function Chunk:genGreenery(val, biome, tile)
	if (math.floor((val) / BIOME_INDEX[biome].green_density + 0.5) == 1)
		and (TILE_INDEX[tile].isGrowable) then
		t = val
		prob = 0
		print(t)
		for x=1, #(BIOME_INDEX[biome].green_index)do
			l = BIOME_INDEX[biome].green_index[x]
			prob = prob + l[2]
			if t < prob then
				return l[1]
			end
		end
		print("Fallback")
		return BIOME_INDEX[biome].green_index[#BIOME_INDEX[biome].green_index][1]
	else
		return 0
	end
end

function Chunk:genEntity(val, biome, tile)
	if (math.floor((val) / BIOME_INDEX[biome].entity_density + 0.5) == 1) 
		and (TILE_INDEX[tile].isSpawnable) then
		t = val
		prob = 0
		for x=1, #(BIOME_INDEX[biome].entity_index)do
			l = BIOME_INDEX[biome].entity_index[x]
			prob = prob + l[2]
			if t < prob then
				return l[1]
			end
		end
	end
	return 0
end

function Chunk:genStructure(val, biome, tile)
	if (math.floor((val - 1) / BIOME_INDEX[biome].struct_density + 0.5) == 1) then
		prob = 0
		t = val
		for x=1, #(BIOME_INDEX[biome].struct_index)do
			l = BIOME_INDEX[biome].struct_index
			prob = prob + l[x][2]
			if t < prob then
				return l[x][1]
			end
		return i
		end
	end
	return 0
end

function Chunk:gen(biome, tile, green, entity, struct)
	tile = self:genTile(tile, biome)
	green = self:genGreenery(green, biome, tile)
	entity = self:genEntity(entity, biome, tile)
	struct = self:genStructure(struct, biome, tile)
	return biome, tile, green, entity, struct
end
