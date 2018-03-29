local Players = game:GetService("Players")

local GameObjectDb = {
	icons = {
		player = "",
		npc1 = ""
	},
	names = {
		-- characters
		player = "",
		npc1 = "Friendly-Looking Guy",
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
			cursorIcon = "rbxgameasset://Images/crowbar-cursor",
		},
		stepLadder = {
			icon = "http://www.roblox.com/asset/?id=32328941",
			cursorIcon = "http://www.roblox.com/asset/?id=32328941",
		},
		universalRemote = {
			icon = "http://www.roblox.com/asset/?id=1375046522",
			cursorIcon = "http://www.roblox.com/asset/?id=1375046522",
		},
	},
	environment = {
		looseBoardScaffolding = {
			toolRequired = "crowbar",
			resolveAction = "unanchor",
			use = {
				none = "That board looks like it could be pried off",
				crowbar = "I managed to pull off the board!",
				stepLadder = "That doesn't make any sense...",
				universalRemote = "I suspect that wooden board is not remote-controllable"
			}
		},
		npc1 = {
			use = {
				none = "Hey man! Welcome to Sideways Town, where you can only walk along a North-South axis!  You uh... you get used to it.",
				crowbar = "Woah dude, cool it!",
				stepLadder = "Woah dude, cool it!",
				universalRemote = "Nice try, but I'm not a robot."
			}
		}
	}
}

-- This is almost entirely static data, but player data does need to get set once
local function updatePlayer(player)
	GameObjectDb.icons.player =
		string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%s&width=420&height=420&format=png632",
			player.UserId)
	GameObjectDb.names.player = player.Name
end

if Players.LocalPlayer then
	updatePlayer(Players.LocalPlayer)
end

Players.PlayerAdded:connect(function(player)
	updatePlayer(player)
end)

return GameObjectDb