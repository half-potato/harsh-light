apackage = {}

function loadAssets(tables)
	if apackage then
		for t=1, #tables do
			for i=1, #tables[t] do
				name = tables[t][i].name
