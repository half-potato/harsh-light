Entity = {}
Entity.__index = Entity
setmetatable(Entity, {
	__call = function (cls, ...)
		return cls.new(...)
	end
})

velZero = {x=0, y=0}

function Entity.new(o)
	assert(o ~= nil)
	setmetatable(o, Entity)
	if not o.actions then
		print("Entity could not load animations.")
		return nil
	end

	o.birthdate = o.birthdate or 0
	o.position = o.position or {x=0, y=0}
	o.desiredposition = o.desiredposition or {x=0, y=0}
	o.velocity = o.velocity or {x=0, y=0}

	if not o.state then
		o.state = "idle"
		o.tSpent = 0
	end
	return o
end

function Entity:updateAnimations(dt)
	-- Deal with animations
	self.tSpent = dt + self.tSpent
	-- Check if the entity is done with the current frame
	if self.tSpent > self.actions[self.state].frames[self.currentF].duration then
		-- Add the remainder to the next timer for the next frame
		self.tSpent = self.tSpent - self.actions[self.state].frames[self.currentF].duration 
		-- Check to see if the current action is done
		if #self.actions[self.state].frames =< self.currentF then
			-- check for next action
			local options, option = self.actions[self.state].nextActions, {}
			local v, prob = love.math.random(), 0
			for i=1, #options do
				prob = prob + options[i][2]
				if v <= prob then
					option = options[i][1]
				end
			end
			-- Deal with next action
			self.state = option
		else
			self.currentF = self.currentF+1
		end
	end

end

function Entity:updateVelocity(dt)
	-- Implementation should depend on the type of entity
end

function Entity:update(dt)
	-- Update other things
	-- Movement is dealt with in the entity controller
	-- Decide next location, update desired position
	self:updateVelocity(dt)
	if self.velocity ~= "i" then
		self.desiredposition = {x= self.velocity.x * dt, y= self.velocity.y * dt}
	end
end

function Entity:checkAge(levelTime)
	return levelTime - self.birthdate
end
