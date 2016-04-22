debug = true

require 'level/Blob'
require 'level/Chunk'
require 'util/Util'
require 'render/AssetPackage'
require 'render/DrawableLevel'

globaltime = 1
tileSize = 84
ox, oy = 0, 0
offx, offy = 0, 0

function love.load(arg)
	love.filesystem.load("loadAssets.lua")()
	map = DrawableLevel:new{seed=3958, mode = "iso", assetPackage = ASSET_PACKAGE}
	map:loadChunk(1, 1)
	map:loadChunk(1, 2)
	map:loadChunk(1, 3)
	map:loadChunk(2, 1)
	map:loadChunk(2, 2)
	map:loadChunk(2, 3)
	map:loadChunk(3, 1)
	map:loadChunk(3, 2)
	map:loadChunk(3, 3)
end

function love.update(dt)
	love.graphics.scale(-1, -1)
	globaltime = dt + globaltime
	map.entityController:update(dt)
end

function love.draw()
	map:drawMap(ox + offx, oy + offy)
	map:drawEntities(ox + offx, oy + offy)
end

function love.mousepressed(x, y, button)
	if button == 1 then
		mx = x
		my = y
	end
end

function love.mousemoved(x, y, dx, dy)
	if mx and my then
		offx = -(mx - x)
		offy = -(my - y)
	end
end

function love.mousereleased(x, y, button)
	mx, my = nil, nil
	ox, oy = ox + offx, oy + offy
	offx, offy = 0, 0
end
