function toIso(x, y)
	angle = math.pi * 3 / 4
	x, y = (2 * y + x) / 2, (2 * y - x) / 2
	return rotate(angle, x, y)
end

function toCaut(x, y)
	local a = (x - y) / 2
	return a, (a + y) / 2
end

function vadd(n, ...)
	if type(...) == 'table' then
		local t = ...

		for i, line in ipairs(t) do
			t[i] = line + n
		end
		return t
	else
		print("Function v-add requires a table as an input.")
		return nil
	end
end

-- Return points of a tile in isometric view as if the center of the tile is the position
function rotatedIsoPoints(degree, tWidth, tHeight)
	-- Rotate around center of tile
	center = {x = tWidth / 2, y = tHeight / 2}

	conversion = 2 * math.pi / 360

	deg = degree + 45

	-- Angles for each of the points + rotation
	a = {}
	a.top = 3 * math.pi / 4 	+ conversion * deg
	a.right = math.pi / 4		+ conversion * deg
	a.bot = 5 * math.pi / 4 	+ conversion * deg
	a.left = 7 * math.pi / 4	+ conversion * deg

	p = {}

	-- Convert angles to points 
	--[[
	p = {math.cos(a.top) * tWidth / 2, math.sin(a.top) * tHeight / 2,
		 math.cos(a.right) * tWidth / 2, math.sin(a.right) * tHeight / 2,
		 math.cos(a.left) * tWidth / 2, math.sin(a.left) * tHeight / 2,
	 	 math.cos(a.bot) * tWidth / 2, math.sin(a.bot) * tHeight / 2}
	]]--
	p = {math.cos(a.top) * tWidth / 2, math.sin(a.top) * tHeight / 2,
		 math.cos(a.right) * tWidth / 2, math.sin(a.right) * tHeight / 2,
		 math.cos(a.left) * tWidth / 2, math.sin(a.left) * tHeight / 2,
	 	 math.cos(a.bot) * tWidth / 2, math.sin(a.bot) * tHeight / 2}
	
	--[[
	p.top.x, p.top.y = toIso(p.top.x, p.top.y)
	p.right.x, p.right.y = toIso(p.right.x, p.right.y)
	p.bot.x, p.bot.y = toIso(p.bot.x, p.bot.y)
	p.left.x, p.left.y = toIso(p.left.x, p.left.y)
	]]
	p[1], p[2] = toIso(p[1], p[2])
	p[3], p[4] = toIso(p[3], p[4])
	p[5], p[6] = toIso(p[5], p[6])
	p[7], p[8] = toIso(p[7], p[8])

	-- Rotate it right because love2d uses some stupid topleft origin

	angle = math.pi * 3 / 4
	vecarray = {}
	for i = 1, 8, 2 do
		-- x, y = rotate(angle, p[i], p[i + 1])
		table.insert(vecarray, {p[i], p[i + 1]})
	end

	return vecarray
end

function rotate(deg, x, y)
	return (math.cos(deg) * x) + (math.sin(deg) * y * -1), math.sin(deg) * x + math.cos(deg) * y
end