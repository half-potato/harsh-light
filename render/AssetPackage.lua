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
		o = getFilesInFolder(o.folder, 10)
	end
	setmetatable(o, AssetPackage)
	return o
end

function AssetPackage:getFile(path)
	local curDir = self
	local splitPath = {}
	for i in string.gmatch(path, "[^/]+") do
		splitPath[#splitPath+1] = i
	end
	for i=1, #splitPath do
		if not curDir then
			print("Could not find the file: \"" .. path .. "\"")
			return nil
		end
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
						local contents = getFilesInFolder(path .. "/" .. fold[i], recursionDepth - 1)
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
	local tinfo = assetPackage:getFile(pathToTileInfo)
	local img = assetPackage:getFile(pathToTilesheet)
	if img and tinfo then
		tinfo = tinfo()
		local imgw = img:getWidth()
		local imgh = img:getHeight()
		for i=1, #table do
			--sometime there can be more than 1 texture per a tile
			local indicies = tinfo.tmeta[table[i].name]
			local quads = {}
			if not indicies then
				print("Could not find the asset for:" .. table[i].name)
				break
			end
			if type(indicies[1]) == type({}) then
				local metas = tinfo.tmeta[table[i].name]
				for i=1, #metas do
					meta = metas[i]
					quads[#quads+1] = love.graphics.newQuad(meta.x, meta.y, meta.width, meta.height, imgw, imgh)
				end
			else
				for i2=1, #indicies do
					-- indicies start at 0
					-- There is a starting seperator
					local index = indicies[i2]
					local yi = math.floor(index / tinfo.sheetW)
					local xi = index % tinfo.sheetW
					local y = tinfo.theight * yi + (yi) * tinfo.seperatorW
					local x = tinfo.twidth * xi + (xi) * tinfo.seperatorW
					quads[#quads+1] = love.graphics.newQuad(x, y, tinfo.twidth, tinfo.theight, imgw, imgh)
				end
			end
			table[i].quads = quads
		end
	else
		if not tinfo then
			print("Could not locate tinfo at path:" .. pathToTileInfo)
		end
		if not img then
			print("Could not locate image at path:" .. pathToTilesheet)
		end
	end
end

-- Edits the table passed in
function loadEntityTable(table, pathToEntityTilesheets, assetPackage)
	for n, entity in pairs(table) do 
		local img = assetPackage:getFile(pathToEntityTilesheets .. "/" .. entity.name .. ".png")
		local tinfo = assetPackage:getFile(pathToEntityTilesheets .. "/" .. entity.name .. ".lua")
		-- Each state represents a row
		if img and tinfo then
			tinfo = tinfo()
			local imgw = img:getWidth()
			local imgh = img:getHeight()
			for stateName, stateInfo in pairs(entity.actions) do
				local quads = {}
				local ty = tinfo.rows[stateName] - 1
				for tx=0, #stateInfo.frames-1 do
					-- There is a starting seperator
					local y = tinfo.theight * ty + (ty * tinfo.seperatorW)
					local x = tinfo.twidth * tx + (tx * tinfo.seperatorW)
					quads[#quads+1] = love.graphics.newQuad(x, y, tinfo.twidth, tinfo.theight, imgw, imgh)
				end
				table[n].actions[stateName].quads = quads
				table[n].actions[stateName].image = img
			end
		end
	end
end
