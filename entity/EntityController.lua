require 'util/Util'
require 'entity/Entity'

EntityController = {}
EntityController.__index = EntityController
setmetatable(EntityController, {
	__call = function (cls, ...)
		return cls.new(...)
	end
})

function EntityController.new(o)
	o = o or {}
	setmetatable(o, EntityController)
	o.entities = o.entities or {"friendlyplayers"={}, "hostileplayers"={} "friendlynpcs"={}, "hostilenpcs"={}}
	-- If tilesize is false, the entity manager will assume that the entities are using tile coordinates
	o.tileSize = o.tileSize
	return o
end

function EntityController:update(dt)
	for role, line in pairs(self.entities) do
		-- Role indiscriminant updates
		for i, 1, #line do
			line[i].update(dt)
			line[i] = self:newEntityWithPos(line[i])
		end
		-- Updates that take role into account
	end
end

-- Returns new entity with new position based on desired position
function EntityController:newEntityWithPos(entity)
	local localcp = deepcopy(entity)
	--Only deal with collisions if the v != i
	if localcp.velocity ~= "i" then
		--Ray trace from current pos to desired pos to check for coll
		local diffx = localcp.desiredposition.x-localcp.position.x
		local diffy = localcp.desiredposition.y-localcp.position.y
		local slopex = diffx / diffy
		local slopey = diffy / diffx
		local dist = math.sqrt(diffx^2 + diffy^2)
		local lastCheckedPos = localcp.position
		for i, 1, math.ceil(dist) do
			local tx = diffx * i + localcp.position.x
			local ty = diffy * i + localcp.position.y
			-- Convert to tile coords if necessary
			if tileSize then
				local doesOccupy = self.map:isTileOpen(math.floor(tx/self.tileSize), math.floor(ty/self.tileSize)) 
			else
				local doesOccupy = self.map:isTileOpen(tx, ty)
			end
			if doesOccupy then
				lastCheckedPos = {x=tx, y=ty}
			else
				localcp.position = lastCheckedPos
				localcp.velocity = velZero
				return localcp
			end
		end
		localcp.position = localcp.desiredposition
		return localcp
	else
		-- For teleportation
		localcp.velocity = velZero
		localcp.position = localcp.desiredposition
		return localcp
	end
end

function EntityController:addEntity(entity, role)
	table.insert(self.entities[role], entity)
end
