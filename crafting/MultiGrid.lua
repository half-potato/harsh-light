require 'util/ClassUtil'
require "crafting/VGrid"

--[[
	How to use:
	MultiGrid is a class for multiple grids working together, for, say, an inventory + crafting.
	If you want it to be empty, write MultiGrid:new{}
	Mostly self explanatory. Use draw() and drawHeldObj() to draw.
	Use drop() and pickUp() to manipulate objects.
]]

MultiGrid = {}
MultiGrid_mt = Class(MultiGrid)

function MultiGrid:new(o)
	o = o or {
		{name = 'def1',
		twidth = 5,
		theight = 5,
		tileSize = 32,
		x = 5, y = 5},
		{name = 'def2',
		twidth = 5,
		theight = 5,
		tileSize = 32,
		x = 100, y = 100},
	}
	-- Can be init with the grids or with the info

	g = {}

	for i, n in ipairs(o) do
		g[#g+1] = VGrid.new{tileSize = n.tileSize, twidth = n.twidth, theight = n.theight, x = n.x, y = n.y}
		--o.grids[#o.grids].x = n.x
		--o.grids[#o.grids].y = n.y
	end

	o.grids = g

	setmetatable(o, MultiGrid_mt)
	o.__index = o

	return o
end

function MultiGrid:addGrid(g)
	self.grids[#self.grids+1] = g
end

-- does not factor in origin
function MultiGrid:getGridsAt(x, y)
	ogs = {}
	for n, i in ipairs(self.grids) do
		w = i.twidth 	* i.tileSize
		h = i.theight 	* i.tileSize
		if ((i.x < x and i.y < y) and (i.x + w > x and i.y + h > y)) then
			ogs[#ogs+1] = i
		end
	end
	if #ogs == 0 then
		return nil
	else
		return ogs
	end
end

function MultiGrid:getGridsIndexAt(x, y)
	ogs = {}
	for n, i in ipairs(self.grids) do
		w = i.twidth 	* i.tileSize
		h = i.theight 	* i.tileSize
		if ((i.x < x and i.y < y) and (i.x + w > x and i.y + h > y)) then
			ogs[#ogs+1] = n
		end
	end
	if #ogs == 0 then
		return nil
	else
		return ogs
	end
end

-- does not factor in origin
function MultiGrid:pickUp(mx, my, gx, gy)
	--[[
	get grid at point
	pickup
	]]
	local gs = self:getGridsAt(mx - gx, my - gy)
	if not (gs == nil) then
		--self.curPickup = gs[1]:pickUpObj(x - gs[1].x, y - gs[1].y)
		-- needs mx, my, gx, gy
		local o = gs[1]:pickUpObj(mx, my, gs[1].x + gx, gs[1].y + gy)
		if not (o == nil) then
			self.curPickup = o.currentPickup
			self.curPickup.width = gs[1].tileSize * self.curPickup.obj.twidth
			self.curPickup.height = gs[1].tileSize * self.curPickup.obj.theight
			self.hobj = HeldObj.new(o.hobj)
			self.hobj.boundingbox = {
				x = 0,
				y = 0,
				width = math.huge,
				height = math.huge
			}
			self.lastPos = {i = self:getGridsIndexAt(mx - gx, my - gy)[1], x = self.curPickup.obj.x, y = self.curPickup.obj.y}
		end
		return true
	else
		return false
	end
end

-- does not factor in origin
function MultiGrid:drop(mx, my, gx, gy)
	--[[
	get grid at point
	drop in grid at point
	]]
	if not (self.curPickup == nil) then
		local gs = self:getGridsAt(mx - gx, my - gy)
		if gs == nil then
			self.grids[self.lastPos.i]:placeObject(self.curPickup.obj, self.lastPos.x, self.lastPos.y)
		else
			local finished = gs[1]:dropObj(self.curPickup, mx, my, gs[1].x + gx, gs[1].y + gy)
			if not (finished) then
				self.grids[self.lastPos.i]:placeObject(self.curPickup.obj, self.lastPos.x, self.lastPos.y)
			end
		end
		self.hobj = nil
		self.curPickup = nil
	end
end

function MultiGrid:draw(x, y)
	for n, i in ipairs(self.grids) do
		i:draw(x + i.x, y + i.y)
	end
end

function MultiGrid:drawHeldObj(mx, my)
	if not (self.hobj == nil) then
		self.hobj:draw(mx, my)
	end
end