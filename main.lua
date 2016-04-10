debug = true

require 'level/Blob'
require 'level/Chunk'
require 'util/Util'
require 'util/Noise'
require 'render/AssetPackage'
require 'render/DrawableBlob'

globaltime = 1
tileSize = 84

function love.load(arg)
   love.filesystem.load("loadAssets.lua")()
   map = DrawableBlob.new{seed=3948, x = 0, y = 0, quadmode = "flat"}
end

function love.update(dt)
   love.graphics.scale(1, -1)
   globaltime = dt + globaltime
end

function love.draw()
   if tmap then
	   love.graphics.draw(tmap, -1100, -200)
   end
   if gmap then
	   love.graphics.draw(gmap, -1100, -200)
   end
   if smap then
	   love.graphics.draw(smap, -1100, -200)
   end
   --[[
   for x=1, 200 do
	   for y=1, 200 do
		   v = math.floor(love.math.noise(x, y) + 0.1) * 255
		   love.graphics.setColor(v, v, v, 255)
		   love.graphics.points(x, y)
	   end
	end
	]]
end

function love.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
end
