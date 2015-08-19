debug = true
require 'level/Tileset'
require 'level/Tilemap'
require 'level/Map'
require 'level/Tile'

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

function love.load(arg)
	p = love.graphics.newImage("assets/Tileset.png")
	tset = Tileset.new(tset)
	tmap = Tilemap.new(tmap)
	map.tileset = tset
	map.tilemap = tmap
	map = Map.new(map)
	map:setAnchor(0.0, 1.0)
end

function love.update(dt)
	globaltime = dt + globaltime
end

function love.draw()
	angle = (180 * math.sin(globaltime / 2) + 180)
	angle = 0
	cp = {x = love.window.getWidth() / 2, y = love.window.getHeight() / 2}
	centerp = {x = cp.x - 000, y = cp.y - 000}
	map:draw(0, 0, 0 * centerp.x, 0 * centerp.y, angle, 0.5)
	love.graphics.point(map:getPos(1, 1, 5))
	love.graphics.point(map:getWidth(), map:getHeight())
end
