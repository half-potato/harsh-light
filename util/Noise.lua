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

	v1 = smoothNoise(fx,    fy    )
	v2 = smoothNoise(fx + 1,fy    )
	v3 = smoothNoise(fx,    fy + 1)
	v4 = smoothNoise(fx + 1,fy + 1)

	i1 = cosInterp(v1, v2, fractX)
	i2 = cosInterp(v3, v4, fractX)

	return cosInterp(i1, i2, fractY)
end

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
end
