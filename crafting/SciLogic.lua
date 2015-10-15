ObjectType = {
	ChemicalReactor = 0
}
Filter = {
	None = 0,
	Liquids = 1,
	Gas = 2,
	FineGrain = 3,
	CourseGrain = 4
}

exobj = {
	name = "Radioactive Isotope",
	imgname = "assets/Tiles/Ground_2.png",
	img = nil,
	otype = ObjectType.ChemicalReactor,
	-- Only intiated at placement
	x = 0,
	y = 0,

	twidth = 5,
	theight = 3,
	flatdata = {0, 0, 'A', 0, 0,
				1, 0,  1 , 0, 0,
				'C', 1,  1 , 1, 'B'},
	-- Elements
	chemistry = {
		carbon14 = 50,
		nitrogen = 40,
		copper3 = 10},
	-- Celsius
	temperature = 100,
	-- Bar
	pressure = 1.5,
	filters = {A = Filter.None,
			   B = Filter.CourseGrain,
			   C = Filter.None}
}