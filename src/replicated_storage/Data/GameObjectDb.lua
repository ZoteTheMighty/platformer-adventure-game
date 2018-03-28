local GameObjectDb = {
	names = {
		-- tools
		crowbar = "Rusty Crowbar",
		stepLadder = "Step Ladder",
		universalRemote = "Universal Remote",
		-- environment
		looseBoardScaffolding = "Loose Board",
	},
	tools = {
		crowbar = {
			icon = "http://www.roblox.com/asset/?id=159050206",
		},
		stepLadder = {
			icon = "http://www.roblox.com/asset/?id=32328941",
		},
		universalRemote = {
			icon = "http://www.roblox.com/asset/?id=1375046522",
		},
	},
	environment = {
		looseBoardScaffolding = {
			toolRequired = "crowbar",
			use = {
				crowbar = "You managed to pull off the board!",
				stepLadder = "That doesn't make any sense...",
				universalRemote = "You suspect that wooden board is not remote-controllable"
			}
		}
	}
}

return GameObjectDb