require 'level/Chunk'
require 'util/Noise'

Blob = {}
Blob.__index = Blob
setmetatable(Blob, {
	__call = function(cls, ...)
		return cls.new(...)
	end,
})

function Blob.new(o)
	o = o or {}
	setmetatable(o, Blob)
	if not o.seed then
		o.seed = love.math.noise(os.time(), os.time())
	end
	if not o.chunks then
		o.chunks = {}
		o:genChunks(-5, -5, 5, 5)
	end
	return o
end

function Blob:genChunk(x, y)
	if not self.chunks[x] then
		self.chunks[x] = {}
	end
	if not self.chunks[x][y] then
		self.chunks[x][y] = Chunk.new{x=x, y=y, seed=self.seed}
	end
end

function Blob:genChunks(x, y, x2, y2)
	for ix = x, x2 do
		for iy = x, y2 do
			self:genChunk(ix, iy)
		end
	end
end

function Blob:getChunkContaining(x, y)
	return self.chunks[math.ceil(x / 16)][math.ceil(y / 16)]
end

function Blob:getData(x, y)
	return self:getChunkContaining(x, y):getData(16 * (x % 16), 16 * (y % 16))
end

function Blob:isTileOpen(x, y)
	local _, _, greenery, entity, structure = self:getData(x, y)
	if greenery.doesOccupy or entity.doesOccupy or structure.doesOccupy then
		return true
	else
		return false
	end
end
