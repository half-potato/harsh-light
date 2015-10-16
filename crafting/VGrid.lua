require 'crafting/Grid'
require 'crafting/HeldObj'

--[[
	How to use:
	VGrid is a subclass of Grid. It remembers tileSize, features held objects, and can confine held objects to the grid.
	gx and gy are the origin of the grid.
	Use draw() and drawHeldObj() to draw the grid.
]]

VGrid = {}
VGrid_mt = { __index = VGrid }

function VGrid.new(obj)

	obj = obj or {
		twidth = 5,
		theight = 5,
		tileSize = 32
	}

	obj.gridImgName = obj.gridImgName or "assets/CGrid.png"

	setmetatable(obj, VGrid_mt)
	setmetatable(VGrid, { __index = Grid })

	obj.objects = {}

	return obj
end

function VGrid:pickUpObj(mx, my, gx, gy)
	self.currentPickup = self:pickUp(mx, my, gx, gy, self.tileSize)
	if not (self.currentPickup == nil) then
		self.currentPickup.width = self.tileSize * self.currentPickup.obj.twidth
		self.currentPickup.height = self.tileSize * self.currentPickup.obj.theight
		self.hobj = HeldObj.new(self.currentPickup)
		--It returns this stuff for multigrid. Not necessary for individual use
		return {hobj = self.hobj, currentPickup = self.currentPickup}
	end
	return nil
end

function VGrid:confineHObjToGrid()
	if not (hobj == nil) then
		self.hobj.boundingbox = {
			x = gx,
			y = gx,
			width = self.tileSize * self.twidth,
			height = self.tileSize * self.theight
		}
	end
end

function VGrid:dropCurrentObj(mx, my, gx, gy)
	if not (self.currentPickup == nil) then
		self:drop(self.currentPickup.obj, mx + self.hobj.rubberX, my + self.hobj.rubberY, 
				  gx, gy, self.tileSize, 
				  self.currentPickup.locOnObjX, self.currentPickup.locOnObjY)
		self.currentPickup = nil
		self.hobj = nil
	end
end

function VGrid:dropObj(o, mx, my, gx, gy)
	return self:drop(o.obj, mx, my, gx, gy, self.tileSize, o.locOnObjX, o.locOnObjY)
end

function VGrid:draw(gx, gy)
	self:drawBackground(gx, gy, (self.gridImg or love.graphics.newImage(self.gridImgName)), self.tileSize)
	self:drawItems(gx, gy, self.tileSize)
end

function VGrid:drawHeldObj(mx, my)
	if not (self.hobj == nil) then
		self.hobj:draw(mx, my)
	end
end