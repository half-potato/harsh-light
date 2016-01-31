require 'util/Util'
require 'util/Img'

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
		o.files = getFilesInFolder(o.folder, 10)
	end
	return o
end

function AssetPacka:getFile(path)
	local curDir = self.files
	local splitPath = {}
	for i in string.gmatch(path, "[^/]+") do
		splitPath[#splitPath+1] = i
	end
	for i=1, #splitPath do
		curDir = curDir[splitPath[i]]
	end
	return curDir
end

function getFilesInFolder(path, recursionDepth)
	local fold = love.filesystem.getDirectoryItems(path)
	local images = {}
	if #fold > 0 then
		for i=1, #fold do
			if love.filesystem.isFile(path .. "/" .. fold[i]) then
				local st = {}
				for p in string.gmatch(fold[i], "[^%.]+") do
					st[#st + 1] = p
				end
				if st[#st] == "png" then
					images[fold[i]] = love.graphics.newImage(path .. "/" .. fold[i])
				elseif st[#st] == "lua" then
					images[fold[i]] = love.filesystem.load(path .. "/" ..fold[i])
				end
			elseif not love.filesystem.isFile(path .. "/" .. fold[i]) then
				if recursionDepth > 0 then
					local d = love.filesystem.getDirectoryItems(path .. "/" .. fold[i])
					if d and #d > 0 then
						local contents = getImagesInFolder(path .. "/" .. fold[i], recursionDepth - 1)
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
				local st = {}
				for p in string.gmatch(fold[i], "[^%.]+") do
					st[#st + 1] = p
				end
				if st[#st] == "png" then
					images[st[1]] = path .. "/" .. fold[i]
				end
			elseif not love.filesystem.isFile(path .. "/" .. fold[i]) then
				if recursionDepth > 0 then
					local d = love.filesystem.getDirectoryItems(path .. "/" .. fold[i])
					if d and #d > 0 then
						local contents = getImagesInFolder(path .. "/" .. fold[i], recursionDepth - 1)
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

-- Edits the table passed in
function loadAssets(table, pathToTilesheet, pathToTileInfo, assetPackage)
	local tinfo = assetPackage:getFile(pathToTileInfo)()
	local img = assetPackage:getFile(pathToTilesheet)
	local imgw = img:getWidth()
	local imgh = img:getHeight()
	if img and tinfo then
		for i=1, #table do
			--sometime there can be more than 1 texture per a tile
			local indicies = tinfo[table[i].name]
			local quads = {}
			if not index then
				local metas = tinfo[table[i].name].meta
				for i=1, #metas do
					meta = meta[i]
					quads[#quads+1] = love.graphics.newQuad(meshPoints(meta.x, meta.y, meta.width, meta.height))
				end
			else
				for i=1, #indicies do
					local index = indicies[i]
					local yi = math.floor(index / tinfo.sheetW)
					local xi = index - yi
					local y = tinfo.theight * yi + (yi-1) * tinfo.seperatorW
					local x = tinfo.twidth * xi + (xi-1) * tinfo.seperatorW
					quads[#quads+1] = love.graphics.newMesh(meshPoints(x, y, tinfo.twidth, tinfo.theight), "fan", "static")
				end
			end
			table[i].quads = quads
		end
	else
		print("Could not locate either the tinfo or image. Path invalid.")
	end
end
