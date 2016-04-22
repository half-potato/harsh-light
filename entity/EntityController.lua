require 'util/Util'
require 'entity/Entity'

EntityController = {}
--[[
EntityController.__index = EntityController
setmetatable(EntityController, {
	__call = function (cls, ...)
		return cls.new(...)
	end
})
]]--

function EntityController:new(o)
	o = o or {}
	setmetatable(o, EntityController)
	self.__index = self
	o.entities = o.entities or {friendlyplayers={}, hostileplayers={}, friendlynpcs={}, hostilenpcs={}}
	-- If tilesize is false, the entity manager will assume that the entities are using tile coordinates
	o.tileSize = o.tileSize
	return o
end

function EntityController:update(dt)
	for role, line in pairs(self.entities) do
		-- Role indiscriminant updates
		for i=1, #line do
			self.entities[role][i]:update(dt)
			local pos, vel = self:updateEntityPos(self.entities[role][i])
			self.entities[role][i].x = pos.x
			self.entities[role][i].y = pos.y
			self.entities[role][i].velocity = vel
			-- unload entities that go off the loaded area
		end
		-- Updates that take role into account
	end
end

-- Returns new entity with new position based on desired position
function EntityController:updateEntityPos(entity)
	--Only deal with collisions if the v != i
	if entity.velocity ~= "i" then
		--Ray trace from current pos to desired pos to check for coll
		--[[local diffx = entity.desiredposition.x-entity.position.x
		local diffy = entity.desiredposition.y-entity.position.y
		local slopex = diffx / diffy
		local slopey = diffy / diffx
		local dist = math.sqrt(diffx^2 + diffy^2)
		local lastCheckedPos = entity.position
		for i=1, math.ceil(dist) do
			local tx = diffx * i + entity.position.x
			local ty = diffy * i + entity.position.y
			-- Convert to tile coords if necessary
			if self.tileSize then
				local doesOccupy = self.map:isTileOpen(math.floor(tx/self.tileSize), math.floor(ty/self.tileSize)) 
			else
				local doesOccupy = self.map:isTileOpen(tx, ty)
			end
			if doesOccupy then
				lastCheckedPos = {x=tx, y=ty}
			else
				entity.position = lastCheckedPos
				entity.velocity = velZero
				return entity
			end
		end]]
		return entity.desiredposition, entity.velocity
	else
		-- For teleportation
		return entity.desiredposition, velZero 
	end
end

function EntityController:addEntity(entity, role, x, y)
	local tx, ty = (x*CHUNK_SIZE) + entity.cx, (y*CHUNK_SIZE) + entity.cy
	if self.tileSize then
		entity.x = tx * self.tileSize
		entity.y = ty * self.tileSize
	else
		entity.x = tx
		entity.y = ty
	end
	table.insert(self.entities[role], entity)
end

function EntityController:unloadArea(x, y, width, height)
	local remEntities = {}
	for i, _ in pairs(self.entities) do
		for n, _ in pairs(self.entities[i]) do
			local e = self.entities[i][n]
			if (e.x >= x and e.y >= y) and (e.x < (x+width) and e.y < (y+width)) then
				local en = table.remove(self.entities[i], n)
				en.cx = math.floor(en.x/(self.tileSize or 1))
				en.cy = math.floor(en.y/(self.tileSize or 1))
				table.insert(remEntities, en)
			end
		end
	end
	return remEntities
end
