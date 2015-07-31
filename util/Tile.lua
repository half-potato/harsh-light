Tile = {}

function Tile:new (objdata)
	objdata = objdata or {}
	setmetatable(objdata, self)
	self.__index = self
	return objdata
end


