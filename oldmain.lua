debug = true
require 'level/Tileset'
require 'level/Tilemap'
require 'level/Map'
require 'level/Tile'

require 'crafting/VGrid'
require 'crafting/MultiGrid'

tset = {prefix = "assets/Tiles/Ground_", suffix = ".png"}
tmap = {tmapname = 'assets/Tileset.png', theight = 128, twidth = 128}
map = {data = {
				{3, 3, 3, 1, 2, 1, 1, 1, 3}, 
				{3, 3, 3, 2, 2, 2, 1, 1, 1},
				{3, 3, 2, 2, 2, 1, 1, 1, 3},
				{3, 3, 2, 2, 2, 1, 1, 3, 3},
				{3, 2, 2, 3, 2, 1, 1, 3, 3},
				{1, 1, 2, 2, 2, 2, 1, 1, 3},
				{1, 1, 1, 2, 2, 2, 2, 1, 1}
			  }}
globaltime = 1
currentPickup = {}
grid = nil
hobj = nil
tileSize = 84
grids = nil

function love.load(arg)
	print("load")
	p = love.graphics.newImage("assets/Tileset.png")
	tset = Tileset.new(tset)
	tmap = Tilemap.new(tmap)
	map.tileset = tset
	map.tilemap = tmap
	map = Map.new(map)
	map:setAnchor(0.0, 1.0)
	grid = VGrid.new{twidth = 6, theight = 6, tileSize = 32};
	print(grid)
	grid:placeObject({
		name = "Radioactive Isotope",
		imgname = "assets/Tiles/Ground_2.png",
		img = nil,
		-- Only intiated at placement
		x = 0,
		y = 0,

		twidth = 2,
		theight = 2,
		flatdata = {1, 1,
					1, 1,},
	}
	, 1, 1)
	grid:placeObject({
		name = "Radioactive Poop",
		imgname = "assets/Tiles/Ground_3.png",
		img = nil,
		-- Only intiated at placement
		x = 0,
		y = 0,
		persistent = true,
		twidth = 3,
		theight = 2,
		flatdata = {1, 1, 1,
					1, 1, 1},
	}
	, 4, 4)
	grid:placeObject({
		name = "Radioactive Isotope",
		imgname = "assets/Tiles/Ground_2.png",
		img = nil,
		-- Only intiated at placement
		x = 0,
		y = 0,

		twidth = 2,
		theight = 2,
		flatdata = {1, 1,
					1, 1,},
	}
	, 5, 1)

	grids = MultiGrid.new()
end

function love.update(dt)
	globaltime = dt + globaltime
end

function love.draw()
	--angle = (180 * math.sin(globaltime / 2) + 180)
	--angle = 0
	cp = {x = love.window.getWidth() / 2, y = love.window.getHeight() / 2}
	centerp = {x = cp.x - 000, y = cp.y - 000}
	--map:draw(0, 0, 0 * centerp.x, 0 * centerp.y, angle, 0.5)
	--love.graphics.point(map:getPos(1, 1, 5))
	--love.graphics.point(map:getWidth(), map:getHeight())Pps
	grid:draw(100, 100)
	grid:drawHeldObj(love.mouse.getX(), love.mouse.getY())
end

function love.mousepressed(x, y, button)
	if button == "l" then
		grid:pickUpObj(x, y, 100, 100)
	end
end

function love.mousereleased(x, y, button)
	if button == "l" then
		grid:dropObj(x, y, 100, 100)
	end
end