debug = true

require 'level/Blob'

globaltime = 1
tileSize = 84

function love.load(arg)
	map = 
end

function love.update(dt)
	globaltime = dt + globaltime
end

function love.draw()
	print(perlinNoise2D(globaltime + 1000003, globaltime + 10000, 1, 3))
end

function love.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
end
