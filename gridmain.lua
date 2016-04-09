debug = true
require 'util/Util'

require 'crafting/VGrid'
require 'crafting/MultiGrid'

grids = nil

function love.load(arg)
	grid = VGrid.new{twidth = 6, theight = 6, tileSize = 32};
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
	}, 4, 4)
	grid.x = 300
	grid.y = 300

	grids = MultiGrid.new()
	grids:addGrid(grid)
end

function love.draw()
	--grid:draw(100, 100)
	grids:draw(100, 100)
	grids:drawHeldObj(love.mouse.getX(), love.mouse.getY())
end

function love.mousepressed(x, y, button)
	if button == 1 then
	grids:pickUp(x, y, 100, 100)
	end
end

function love.mousereleased(x, y, button)
	if button == 1 then
	grids:drop(x, y, 100, 100)
	end
end
