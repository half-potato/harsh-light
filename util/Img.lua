function meshPoints(x, y, width, height, mode)
	cases = {"iso" = {
		--Creates a diamond, its up to you to scale the tile size dimensions properly
		{x, y+0.5*height},
		{x+0.5*width, y},
		{x+1*width, y+0.5*height},
		{x+0.5*width, y+1*height}
	}, "flat" = {
		{x, y},
		{x+1*width, y},
		{x+1*width, y+1*height},
		{x, y+1*height}
	}}
	return cases[mode]
end
