debug = true
require 'level/Tileset'
require 'level/Tilemap'
require 'level/Map'
require 'level/Tile'

tset = {prefix = "assets/Tiles/Ground_", suffix = ".png"}
tmap = {tmapname = 'assets/Tileset.png', theight = 128, twidth = 128}
map = {data = {{3, 1, 2}, {1, 2, 3}}}
globaltime = 1

function love.load(arg)
	p = love.graphics.newImage("assets/Tileset.png")
	tset = Tileset.new(tset)
	tmap = Tilemap.new(tmap)
	map.tileset = tset
	map.tilemap = tmap
	map = Map.new(map)
end

function love.update(dt)
	globaltime = dt + globaltime
end

function love.draw()
	angle = (180 * math.sin(globaltime / 2) + 180)
	map:setAngle(angle)
	map:draw(300, 300, 128, 64)
end
