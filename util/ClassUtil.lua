function inherit(baseClass)
	local newclass = {}
	local class_metatable = { __index = newclass }

	function newclass:create()
		local newinst = {}
		setmetatable(newinst, class_metatable)
		return newinst
	end

	if baseClass then
		setmetatable(newclass, { __index = baseClass })
	end

	return newclass
end

function Class(members)
	members = members or {}
	local mt = {
		__metatable = members;
		__index     = members;
	}
	local function new(_, init)
		return setmetatable(init or {}, mt)
	end
	local function copy(obj, ...)
		local newobj = obj:new(unpack(arg))
		for n,v in pairs(obj) do newobj[n] = v end
		return newobj
	end
	members.new  = members.new  or new
	members.copy = members.copy or copy
	return mt
end