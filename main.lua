debug = true

require 'level/Blob'
require 'level/Chunk'
require 'util/Util'

globaltime = 1
tileSize = 84

function love.load(arg)
	map = Chunk.new{seed=1230971384, x = 0, y = 0}
	print_r(map)
end

function love.update(dt)
	globaltime = dt + globaltime
end

function love.draw()
end

function love.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
end
