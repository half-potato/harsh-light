AssetPackage = {}
AssetPackage.__index = AssetPackage
setmetatable(AssetPackage, {
	__call = function(cls, ...)
		return cls.new(...)
	end,
})

function AssetPackage.new(o)
	o = o or {}
	setmetatable(o, self)
	return o
end

function AssetPackage:loadFolder(path)

end

function AssetPackage:loadFolderRecursively(path)

end
