-- Can be optimized, grid could store TileType as an array instead of cycling through all objects everytime. Probably neglectable
-- FindNearestSpotFor can be optimized

require 'util/Util'

--[[
	How to use:
	Grid is a class independent of pixel height. It only knows tile width and height. 
	To draw, use drawBackground() and drawItems()
	To add items directly with no space check, use addObject()
	To add items with space checking, use drop(). If there is no space, it will not place it and will return false
	To pickup objects, use pickUp(). This returns an array with the obj and location where the mouse was on the object. Returns nil if nothing is there
	getTileTypes and getObjectsAt both return arrays to make the functions useful with objects overlapping
	The version that automatically shows held objects and remembers tile size is VGrid
]]

TileType = {
	Empty = 0,
	Filler = 1
}
exobj = {
	name = "Radioactive Isotope",
	imgname = "assets/Tiles/Ground_2.png",
	img = nil,
	-- Only intiated at placement
	x = 0,
	y = 0,

	twidth = 5,
	theight = 3,
	flatdata = {0, 0, 'A', 0, 0,
				1, 0,  1 , 0, 0,
				'C', 1,  1 , 1, 'B'},
	persistent = false
}

Grid = {}
Grid.__index = Grid

setmetatable(Grid, {
	__call = function(cls, ...)
		return cls.new(...)
	end,
})

function Grid.new(o)
	o = o or {
		twidth = 5,
		theight = 5
	}
	setmetatable(o, Grid)
	o.__index = o

	o.objects = {}
	return o
end

function Grid:getTileTypes(x, y)
	local tiles = {}
	for i, line in ipairs(self:getObjectsAt(x, y)) do
		local xinline = x - line.x
		local yinline = y - line.y
		local iinline = xinline + ((yinline - 1) * line.twidth)
		tiles[#tiles+1] = line.flatdata[iinline]
	end
	if tiles[#tiles] == nil then
		return {TileType.Empty}
	else
		return tiles
	end
end

function Grid:placeObject(o, x, y)
	o.x = x
	o.y = y
	self.objects[#self.objects+1] = o
end

function Grid:getObjectsAndIndiciesAt(x, y)
	local objects = {}
	if ((x > 0 and y > 0) and (x <= self.twidth and y <= self.theight)) then
		for i, line in ipairs(self.objects) do
			-- If is within object
			if ((line.x < x) and (line.y < y)) and (((line.x + line.twidth) >= x) and (((line.y + line.theight) >= y))) then
				objects[#objects + 1] = {line, i}
			end
		end
	end
	return objects
end

function Grid:getObjectsAt(x, y)
	local objects = {}
	if ((x > 0 and y > 0) and (x <= self.twidth and y <= self.theight)) then
		for i, line in ipairs(self.objects) do
			-- If is within object
			if ((line.x < x) and (line.y < y)) and (((line.x + line.twidth) >= x) and (((line.y + line.theight) >= y))) then
				objects[#objects + 1] = line
			end
		end
	end
	return objects
end

function Grid:canPlaceObjectAt(o, x, y)
	if ((x < 0 or y < 0) or (x > self.twidth - 2 or y > self.theight - 2)) then
		return false
	end

	if ((x + o.twidth > self.twidth) or (y + o.theight > self.theight)) then
		return false
	end

	for n, i in ipairs(o.flatdata) do
		-- Check if our object has an empty spot
		if not (i == TileType.Empty) then
			local yin = math.ceil(n / o.twidth) - 1
			local xin = (n - (yin * o.twidth))
			yin = yin + 1

			-- Then check if the point has an empty spot
			for p, c in ipairs(self:getTileTypes(xin + x, yin + y)) do
				if not (c == TileType.Empty) then
					return false
				end
			end
		end
		-- If both succeed, the spot was empty. Onwards.
	end
	return true
end

function Grid:findNearestSpotFor(o, x, y)
	if(self:canPlaceObjectAt(o, x, y)) then
		return {x, y}
	else
		-- Try moving it to the four adjacent tiles. This is really lazy
		if(self:canPlaceObjectAt(o, x + 1, y)) then
			return {x + 1, y}
		elseif(self:canPlaceObjectAt(o, x - 1, y)) then
			return {x - 1, y}
		elseif(self:canPlaceObjectAt(o, x, y + 1)) then
			return {x, y + 1}
		elseif(self:canPlaceObjectAt(o, x, y - 1)) then
			return {x, y - 1}
		else
			return nil
		end
	end
end

function Grid:drawBackground(x, y, image, sizeOfSideOfSquare)
	local sbatch = love.graphics.newSpriteBatch(image, self.twidth * self.theight)
	local scaleFactorX = sizeOfSideOfSquare / image:getHeight()
	local scaleFactorY = sizeOfSideOfSquare / image:getWidth()
	for i = 0, self.twidth - 1, 1 do
		for p = 0, self.theight - 1, 1 do
			sbatch:add((i * sizeOfSideOfSquare), (p * sizeOfSideOfSquare), 0, scaleFactorX, scaleFactorY)
		end
	end
	love.graphics.draw(sbatch, x, y)
end

function Grid:drawItems(x, y, sizeOfSideOfSquare)
	for n, i in ipairs(self.objects) do
		if i.img == nil then
			i.img = love.graphics.newImage(i.imgname or "assets/Tiles/Ground_1.png")
		end
		local q = love.graphics.newQuad(0, 0, i.twidth * sizeOfSideOfSquare, i.theight * sizeOfSideOfSquare, i.twidth * sizeOfSideOfSquare, i.theight * sizeOfSideOfSquare)
		local posx = x + (sizeOfSideOfSquare * i.x)
		local posy = y + (sizeOfSideOfSquare * i.y)
		
		love.graphics.draw(i.img, q, posx, posy)
	end
end

function Grid:pickUp(mousex, mousey, gridx, gridy, sizeOfSideOfSquare)
	local tx = round((mousex - gridx - (sizeOfSideOfSquare / 2)) / sizeOfSideOfSquare) + 1
	local ty = round((mousey - gridy - (sizeOfSideOfSquare / 2)) / sizeOfSideOfSquare) + 1
	local objects = self:getObjectsAndIndiciesAt(tx, ty)
	if (self:getTileTypes(tx, ty) == TileType.Empty) or (objects[#objects] == nil) then
		return nil
	else
		local fobj = objects[#objects][1]
		if not (fobj.persistent == true) then
			table.remove(self.objects, objects[#objects][2])
		end
		-- Find object origin in terms of pixels
		local pobjx = fobj.x * sizeOfSideOfSquare + gridx
		local pobjy = fobj.y * sizeOfSideOfSquare + gridy

		local locOnTilex = mousex - pobjx
		local locOnTiley = mousey - pobjy

		return {locOnObjX = locOnTilex, locOnObjY = locOnTiley, obj = fobj}
	end
end

function Grid:drop(o, mousex, mousey, gridx, gridy, sizeOfSideOfSquare, locOnTilex, locOnTiley)
	local tx = round((mousex - gridx - locOnTilex) / sizeOfSideOfSquare)
	local ty = round((mousey - gridy - locOnTiley) / sizeOfSideOfSquare)
	local pos = self:findNearestSpotFor(o, tx, ty)
	if not (pos == nil) then
		if o.persistent then
			obj = deepcopy(o)
			obj.persistent = false
			self:placeObject(obj, pos[1], pos[2])
		else
			self:placeObject(o, pos[1], pos[2])
		end
		return true
	else
		return false
	end
end