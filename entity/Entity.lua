Entity = {}
Entity.__index = Entity
setmetatable(Entity, {
	__call = function (cls, ...)
		return cls.new(...)
	end
})

function Entity.new(o)
	o = o or {}
	setmetatable(o, Entity)
	if not o.actions then
		print("Entity could not load animations.")
		return nil
	end
	if not o.birthdate then
		o.birthdate = 0
	end
	if not o.state then
		o.state = "idle"
		o.tSpent = 0
	end
	return o
end

function Entity:update(dt)
	-- Deal with animations
	self.tSpent = dt + self.tSpent
	if self.tSpent > self.actions[self.state].frames[self.currentF].duration then
		self.tSpent = self.tSpent - self.actions[self.state].frames[self.currentF].duration 
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

	-- Update other things
	-- Movement is dealt with in the entity controller
end

function Entity:checkAge(levelTime)
	return levelTime - self.birthdate
end
