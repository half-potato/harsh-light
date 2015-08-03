debug = true
require 'util/Tileset'
require 'util/Tile'

o = {tsetname = "assets/Tileset.png", twidth = 128, theight = 128}
globaltime = 0

function love.load(arg)
	o = Tileset.new(o)
	p = love.graphics.newImage("assets/Tileset.png")
end

function love.update(dt)
	globaltime = dt + globaltime
end

function love.draw()
	love.graphics.print("Hello World", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
	-- love.graphics.draw(o.tset, o[2], 100, 100)
	angle = (180 * math.sin(globaltime / 2) + 180)
	pts = rotatedIsoPoints(angle, o.twidth, o.theight)
	np = {5, 2, 4, 9, 10, 20}
	--[[
	np2 = { pts.top.x, pts.top.y, 
			pts.right.x, pts.right.y,
			pts.bot.x, pts.bot.y, 
			pts.left.x, pts.left.y}
	np2 = vadd(100, np2)
	]]
	pts = vadd(100, pts)
	print(angle)
	love.graphics.polygon('fill', pts)
end
