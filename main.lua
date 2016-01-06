debug = true

require 'level/Blob'
require 'level/Chunk'
require 'util/Util'
require 'util/Noise'

globaltime = 1
tileSize = 84

function love.load(arg)
	map = Chunk.new{seed=5, x = 0, y = 0}
	print_r(map)
end

function love.update(dt)
	globaltime = dt + globaltime
end

function love.draw()
	draw(300, 300)
end

function love.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
end
