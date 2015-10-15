HeldObj = {}
HeldObj.__index = HeldObj

setmetatable(HeldObj, {
	__call = function(cls, ...)
		return cls.new(...)
	end,
})

function HeldObj.new(o)
	o = o or {
		locOnObjX = 0,
		locOnObjY = 0,
		width = 32,
		height = 32,
		boundingbox = {
			x = 0,
			y = 0,
			width = math.huge,
			height = math.huge
		},
		obj = {img = nil,
		 imgname = ""}
	}
	o.rubberX = 0
	o.rubberY = 0
	setmetatable(o, HeldObj)
	o.__index = o
	return o
end

function pt(x, y)
	love.graphics.setPointSize(10)
	love.graphics.point(x, y)
end

function HeldObj:draw(x, y)
	q = love.graphics.newQuad(0, 0, self.width, self.height, self.width, self.height)
	if self.obj.img == nil then
		self.obj.img = love.graphics.newImage(self.obj.imgname or "assets/Tiles/Ground_1.png")
	end

	local outeredgeX = x - self.locOnObjX + self.width
	local outeredgeY = y - self.locOnObjY + self.height
	local inneredgeX = x - self.locOnObjX
	local inneredgeY = y - self.locOnObjY

	-- An operation to make it zero if the result is not positive: p = (n / 2) + abs(n / 2)

	local ox = self.boundingbox.x
	local oy = self.boundingbox.y
	local h = self.boundingbox.height
	local w = self.boundingbox.width

	local bx = ox - inneredgeX
	bx = -((-bx / 2) - math.abs(-bx / 2))
	local by = oy - inneredgeY
	by = -((-by / 2) - math.abs(-by / 2))

	local tx = outeredgeX - (ox + w)
	tx = ((-tx / 2) - math.abs(-tx / 2))
	local ty = outeredgeY - (oy + h)
	ty = ((-ty / 2) - math.abs(-ty / 2))

	self.rubberX = bx + tx
	self.rubberY = by + ty

	love.graphics.draw(self.obj.img, q, x - self.locOnObjX + self.rubberX, y - self.locOnObjY + self.rubberY)
end