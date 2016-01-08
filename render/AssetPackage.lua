require 'util/Util'

AssetPackage = {}
AssetPackage.__index = AssetPackage
setmetatable(AssetPackage, {
	__call = function(cls, ...)
		return cls.new(...)
	end,
})

function AssetPackage.new(o)
	o = o or {}
	setmetatable(o, AssetPackage)
	if o.folder then
		o.images = getImagesInFolder(o.folder, 5)
	end
	return o
end


function getImagesInFolder(path, recursionDepth)
	local fold = love.filesystem.getDirectoryItems(path)
	local images = {}
	if #fold > 0 then
		for i=1, #fold do
			if love.filesystem.isFile(path .. "/" .. fold[i]) then
				st = {}
				for p in string.gmatch(fold[i], "[^%.]+") do
					st[#st + 1] = p
				end
				if st[#st] == "png" then
					images[st[1]] = love.graphics.newImage(path .. "/" .. fold[i])
				end
			elseif not love.filesystem.isFile(path .. "/" .. fold[i]) then
				if recursionDepth > 0 then
					d = love.filesystem.getDirectoryItems(path .. "/" .. fold[i])
					if d and #d > 0 then
						contents = getImagesInFolder(path .. "/" .. fold[i], recursionDepth - 1)
						if contents then
							images[fold[i]] = {}
							for k, v in pairs(contents) do
								images[fold[i]][k] = v
							end
						end
					end
				end
			end
		end
		return images
	else
		return nil
	end
end

function getImageNamesInFolder(path, recursionDepth)
	local fold = love.filesystem.getDirectoryItems(path)
	local images = {}
	if #fold > 0 then
		for i=1, #fold do
			if love.filesystem.isFile(path .. "/" .. fold[i]) then
				st = {}
				for p in string.gmatch(fold[i], "[^%.]+") do
					st[#st + 1] = p
				end
				if st[#st] == "png" then
					images[st[1]] = path .. "/" .. fold[i]
				end
			elseif not love.filesystem.isFile(path .. "/" .. fold[i]) then
				if recursionDepth > 0 then
					d = love.filesystem.getDirectoryItems(path .. "/" .. fold[i])
					if d and #d > 0 then
						contents = getImagesInFolder(path .. "/" .. fold[i], recursionDepth - 1)
						if contents then
							images[fold[i]] = {}
							for k, v in pairs(contents) do
								images[fold[i]][k] = v
							end
						end
					end
				end
			end
		end
		return images
	else
		return nil
	end
end
