require 'entity/EntityController'
require 'entity/TypicalRoles'
require 'util/Util'
require 'level/Blob'

Level = Blob:new()
--[[
Level.__index = Level
setmetatable(Level, {
	__index = Blob,
	__call = function(cls, ...)
		return cls.new(...)
	end,
})
]]--

function Level:new(o)
	o = o or {}
	--o = Blob.new(o)
	setmetatable(o, Level)
	self.__index = self
	o.loadedChunks = o.loadedChunks or {}
	o.entityController = o.entityController or EntityController:new{tileSize = o.tileSize or nil}
	o.entityController.map = o
	--[[
	if not o.seed then
		o.seed = love.math.noise(os.time(), os.time())
	end
	o.existingChunks = o.existingChunks or {}
	o.chunks = o.chunks or {}
	]]
	return o
end

function Level:loadChunk(x, y)

	-- Make sure chunk has not already been loaded
	for i=1, #self.loadedChunks do
		if ((self.loadedChunks[i].x == x) and (self.loadedChunks[i].y == y)) then
			print("Already loaded chunk")
		end
	end
	table.insert(self.loadedChunks, {x=x, y=y})

	-- Gen chunk if not there
	if not self.chunks[x] then
		self.chunks[x] = {}
	end
	if not self.chunks[x][y] then
		Level.genChunk(self, x, y)
	end

	-- Load entities into entity controller
	local entities = self.chunks[x][y].entities
	for i, entity in pairs(entities) do
		local role = TYPICAL_ROLES[entity.name]
		local en = love.filesystem.load("entity/Assign.lua")(entity)
		self.entityController:addEntity(en, role, x, y)
	end
end

-- chunks has the format {{x=x, y=y}, {x=x, y=y}}
function Level:loadChunks(chunks)
	for i, line in chunks do
		self:loadChunk(line.x, line.y)
	end
end

function Level:unloadChunk(x, y)
	local mul = (self.tileSize or 1)*CHUNK_SIZE
	local entities = self:unloadArea(x*mul, y*mul, mul, mul)
	self.chunks[x][y].entities = entities
end

function Level:genChunk(x, y)
	-- Generate row if non-existent
	if not self.chunks[x] then
		self.chunks[x] = {}
	end
	if not self.chunks[x][y] then
		self.chunks[x][y] = Chunk:new{x=x, y=y, seed=self.seed}
		table.insert(self.existingChunks, {x=x, y=y})
	end
end
