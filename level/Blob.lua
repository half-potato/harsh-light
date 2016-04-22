require 'level/Chunk'

Blob = {}
--[[
Blob.__index = Blob
setmetatable(Blob, {
	getType = function(self)
		return self.typeName
	end,
	inherit = function (self, t, methods)
		local mtnew = {__index = setmetatable(methods, {__index=self})}
		return setmetatable(t or {}, mtnew)
	end,

	__call = function(cls, ...)
		return cls.new(...)
	end,
})
]]--

function Blob:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	if not o.seed then
		o.seed = love.math.noise(os.time(), os.time())
	end
	o.existingChunks = o.existingChunks or {}
	o.chunks = o.chunks or {}
	return o
end

function Blob:genChunk(x, y)
	-- Generate row if non-existent
	if not self.chunks[x] then
		self.chunks[x] = {}
	end
	if not self.chunks[x][y] then
		self.chunks[x][y] = Chunk.new{x=x, y=y, seed=self.seed}
		table.insert(self.existingChunks, {x=x, y=y})
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
	if self.chunks[math.ceil(x/16)] then
		return self.chunks[math.ceil(x / 16)][math.ceil(y / 16)]
	end
	return nil
end

function Blob:getData(x, y)
	local chunk = self:getChunkContaining(x, y)
	if chunk then
		return chunk:getData(16 * (x % 16), 16 * (y % 16))
	else
		return nil
	end
end

function Blob:isTileOpen(x, y)
	local _, _, greenery, entity, structure = self:getData(x, y)
	if greenery and entity and structure then
		if greenery.doesOccupy or entity.doesOccupy or structure.doesOccupy then
			return true
		else
			return false
		end
	else
		return false
	end
end
