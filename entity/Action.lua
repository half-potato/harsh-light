-- Add actions to entities (to avoid cluttering
local entitytable = ...

entitytable[1].actions = {
	idle = {
		imageName = "SandHowler",
		frames = {
			0.5
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	},
	flashing = {
		imageName = "SandHowlerFlash",
		frames = {
			0.5, 0.5
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
}
entitytable[2].actions = {
	idle = {
		imageName = "FrostGale",
		frames = {
			0.5
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	},
	flashing = {
		imageName = "FrostGaleFlash",
		frames = {
			0.5, 0.5
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
}
entitytable[3].actions = {
	idle = {
		imageName = "Crab",
		frames = {
			0.5
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	},
	flashing = {
		imageName = "CrabFlash",
		frames = {
			0.5,
			0.5
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
}
entitytable[4].actions = {
	idle = {
		imageName = "Spinefin",
		frames = {
			0.5
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	},
	flashing = {
		imageName = "SpinefinFlash",
		frames = {
			0.5,
			0.5
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
}
entitytable[5].actions = {
	idle = {
		imageName = "Scorpion",
		frames = {
			0.5
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	},
	flashing = {
		imageName = "ScorpionFlash",
		frames = {
			0.5,
			0.5
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
}
entitytable[6].actions = {
	idle = {
		imageName = "Sandwurm",
		frames = {
			0.5
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	},
	flashing = {
		imageName = "SandwurmFlash",
		frames = {
			0.5,
			0.5
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
}
entitytable[7].actions = {
	idle = {
		imageName = "Earthworm",
		frames = {
			0.5
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	},
	flashing = {
		imageName = "EarthwormFlash",
		frames = {
			0.5,
			0.5
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
}
entitytable[8].actions = {
	idle = {
		imageName = "Bluejay",
		frames = {
			0.5
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	},
	flashing = {
		imageName = "BluejayFlash",
		frames = {
			0.5,
			0.5
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
}
entitytable[9].actions = {
	idle = {
		imageName = "Hawk",
		frames = {
			0.5
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	},
	flashing = {
		imageName = "HawkFlash",
		frames = {
			0.5,
			0.5
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
}
entitytable[10].actions = {
	idle = {
		imageName = "Crow",
		frames = {
			0.5
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	},
	flashing = {
		imageName = "CrowFlash",
		frames = {
			0.5,
			0.5
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
}
entitytable[11].actions = {
	idle = {
		imageName = "Roadhog",
		frames = {
			0.5
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	},
	flashing = {
		imageName = "RoadhogFlash",
		frames = {
			0.5,
			0.5
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
}
entitytable[12].actions = {
	idle = {
		imageName = "SerBuffalo",
		frames = {
			0.5
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	},
	flashing = {
		imageName = "SerBuffaloFlash",
		frames = {
			0.5,
			0.5
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
}
entitytable[13].actions = {
	idle = {
		imageName = "Squirrel",
		frames = {
			0.5
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	},
	flashing = {
		imageName = "SquirrelFlash",
		frames = {
			0.5,
			0.5
		},
		nextActions = {
			{"idle", 0.5},
			{"flashing", 0.5}
		}
	}
}

return entitytable
