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
	if not o.seed then
		o.seed = love.math.noise(os.time(), os.time())
	end
	if not o.chunks then
		self.chunks = {}
	end
	setmetatable(o, Blob)
	o:genChunks(-5, -5, 5, 5)
	return o
end

function Blob:genChunks(x, y, x2, y2)
	for ix = x, x2 do
		if not o.chunks[ix] then
			o.chunks[ix] = {}
		end
		for iy = x, y2 do
			self.chunks[ix][iy] = Chunk.new{x=ix, y=iy, seed=self.seed}
		end
	end
end

function Blob:getChunkContaining(x, y)
	return self.chunks[math.ceil(x / 16)][math.ceil(y / 16)]
end

function Blob:getData(x, y)
	return self:getChunkContaining(x, y):getData(16 * (x % 16), 16 * (y % 16))
end
