require 'level/entity/Entity'
-- Add actions to entities (to avoid cluttering

ENTITY_INDEX[1].actions = {
	idle = {
		imageName = "SandHowler",
		frames = {
			0.01
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
	flashing = {
		imageName = "SandHowlerFlash",
		frames = {
			0.01, 0.01
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
}
ENTITY_INDEX[2].actions = {
	idle = {
		image = "FrostGale",
		frames = {
			0.01
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
	flashing = {
		image = "FrostGaleFlash",
		framesDurations = {
			0.5, 0.5
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
}
--[[
ENTITY_INDEX[3].actions = {
	idle = {
		frames = {
			{image = "Crab", number = 1, duration = 0.01},
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
	flashing = {
		frames = {
			{image = "CrabFlash", number = 0, duration = 0.01},
			{image = "CrabFlash", number = 1, duration = 0.01},
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
}
ENTITY_INDEX[4].actions = {
	idle = {
		frames = {
			{image = "Spinefin", number = 1, duration = 0.01},
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
	flashing = {
		frames = {
			{image = "SpinefinFlash", number = 0, duration = 0.01},
			{image = "SpinefinFlash", number = 1, duration = 0.01},
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
}
ENTITY_INDEX[5].actions = {
	idle = {
		frames = {
			{image = "Scorpion", number = 1, duration = 0.01},
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
	flashing = {
		frames = {
			{image = "ScorpionFlash", number = 0, duration = 0.01},
			{image = "ScorpionFlash", number = 1, duration = 0.01},
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
}
ENTITY_INDEX[6].actions = {
	idle = {
		frames = {
			{image = "Sandwurm", number = 1, duration = 0.01},
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
	flashing = {
		frames = {
			{image = "SandwurmFlash", number = 0, duration = 0.01},
			{image = "SandwurmFlash", number = 1, duration = 0.01},
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
}
ENTITY_INDEX[7].actions = {
	idle = {
		frames = {
			{image = "Earthworm", number = 1, duration = 0.01},
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
	flashing = {
		frames = {
			{image = "EarthwormFlash", number = 0, duration = 0.01},
			{image = "EarthwormFlash", number = 1, duration = 0.01},
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
}
ENTITY_INDEX[8].actions = {
	idle = {
		frames = {
			{image = "Bluejay", number = 1, duration = 0.01},
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
	flashing = {
		frames = {
			{image = "BluejayFlash", number = 0, duration = 0.01},
			{image = "BluejayFlash", number = 1, duration = 0.01},
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
}
ENTITY_INDEX[9].actions = {
	idle = {
		frames = {
			{image = "Hawk", number = 1, duration = 0.01},
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
	flashing = {
		frames = {
			{image = "HawkFlash", number = 0, duration = 0.01},
			{image = "HawkFlash", number = 1, duration = 0.01},
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
}
ENTITY_INDEX[10].actions = {
	idle = {
		frames = {
			{image = "Crow", number = 1, duration = 0.01},
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
	flashing = {
		frames = {
			{image = "CrowFlash", number = 0, duration = 0.01},
			{image = "CrowFlash", number = 1, duration = 0.01},
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
}
ENTITY_INDEX[11].actions = {
	idle = {
		frames = {
			{image = "Roadhog", number = 1, duration = 0.01},
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
	flashing = {
		frames = {
			{image = "RoadhogFlash", number = 0, duration = 0.01},
			{image = "RoadhogFlash", number = 1, duration = 0.01},
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
}
ENTITY_INDEX[12].actions = {
	idle = {
		frames = {
			{image = "SerBuffalo", number = 1, duration = 0.01},
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
	flashing = {
		frames = {
			{image = "SerBuffaloFlash", number = 0, duration = 0.01},
			{image = "SerBuffaloFlash", number = 1, duration = 0.01},
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
}
ENTITY_INDEX[13].actions = {
	idle = {
		frames = {
			{image = "Squirrel", number = 1, duration = 0.01},
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
	flashing = {
		frames = {
			{image = "SquirrelFlash", number = 0, duration = 0.01},
			{image = "SquirrelFlash", number = 1, duration = 0.01},
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
}
]]
