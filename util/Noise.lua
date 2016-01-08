function cubicInterp(v0, v1, v2, v3, x)
	-- the difference between the slopes on either side of x
	P = (v3 - v2) - (v0 - v1)
	Q = (v0 - v1) - P
	R = v2 - v0
	-- start point
	S = v1
	return P * math.pow(x, 3) + Q * math.pow(x, 2) + R * x + S
end

function cosInterp(a, b, x)
	ft = x * math.pi
	f = (1 - math.cos(ft)) * .5
	return a*(1-f) + b*f
end

function smoothNoise(x, y)
	corners = (love.math.noise(x-1, y-1)+love.math.noise(x+1, y-1)+love.math.noise(x-1, y+1)+love.math.noise(x+1, y+1)) / 16
	sides = (love.math.noise (x-1, y)+love.math.noise(x+1, y)+love.math.noise(x, y-1)+love.math.noise(x, y+1)) / 8
	center = love.math.noise(x, y) / 4

	return corners + sides + center
end

function interpNoise(x, y)
	fx = math.floor(x)
	fy = math.floor(y)

	fractX = x - fx
	fractY = y - fy

	v1 = love.math.noise(fx,    fy    )
	v2 = love.math.noise(fx + 1,fy    )
	v3 = love.math.noise(fx,    fy + 1)
	v4 = love.math.noise(fx + 1,fy + 1)

	i1 = cosInterp(v1, v2, fractX)
	i2 = cosInterp(v3, v4, fractX)

	return cosInterp(i1, i2, fractY)
end
--[[
function perlinNoise2D(x, y, persistence, octave)
	total = 0
	p = persistence
	n = octave - 1

	for i=0, n do
		freq = math.pow(2, i)
		amp = math.pow(p, i)
		total = total + interpNoise(x * freq, y * freq) * amp
	end
	return total
end]]

function noiseValue(x, y, freq, amp)
	return love.math.noise(x / freq, y / freq) * amp
end

function perlinNoise2D(x, y, amp, freq, octaves)
	mapMin = interpNoise(0, 0)
	mapMax = mapMin
	n = 0
	for i = 1, octaves do
		n = n + noiseValue(x, y, freq / i, amp / i)
	end
	mapMin = math.min(mapMin, n)
	mapMax = math.max(mapMax, n)

	mapMulti = 1 / (mapMax - mapMin)
	return n * mapMulti
end

function genMap(mapWidth, mapHeight, max, freq)
	mapMin = interpNoise(0, 0)
	mapMax = mapMin
	map = {}
	amp = 100
	octaves = 6
	for x = 1, mapWidth do
		map[x] = {}
		for y = 1, mapHeight do
			map[x][y] = 0
			for i = 1, octaves do
				map[x][y] = map[x][y] + noiseValue(x, y, freq / i, amp / i)
			end
			mapMin = math.min(mapMin, map[x][y])
			mapMax = math.max(mapMax, map[x][y])
		end
	end

	mapMultiplier = max / (mapMax - mapMin)
	for x = 1, mapWidth do
		for y = 1, mapHeight do
			map[x][y] = map[x][y] * mapMultiplier
			map[x][y] = math.min(map[x][y], max)
		end
	end
	return map
end

function draw(mapWidth, mapHeight)
	nmap = genMap(mapWidth, mapHeight, 255, 256)
	for x = 1, mapWidth do
		for y = 1, mapHeight do
			love.graphics.setColor(nmap[x][y], nmap[x][y], nmap[x][y], 255)
			love.graphics.points(x, y)
		end
	end
end
