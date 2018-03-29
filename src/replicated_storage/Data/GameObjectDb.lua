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
		-- items
		crowbar = "Rusty Crowbar",
		truckKey = "Truck Key",
		-- environment
		looseBoardScaffolding = "Loose Board",
	},
	items = {
		crowbar = {
			icon = "http://www.roblox.com/asset/?id=159050206",
			cursorIcon = "rbxgameasset://Images/crowbar-cursor",
		},
		truckKey = {
			icon = "http://www.roblox.com/asset/?id=1391250210",
			cursorIcon = "rbxgameasset://Images/crowbar-cursor",
		},
	},
	environment = {
		looseBoardScaffolding = {
			itemRequired = "crowbar",
			resolveAction = "unanchor",
			consumesItem = false,
			interact = {
				none = "That board looks like it could be pried off",
				crowbar = "I managed to pull off the board!",
				truckKey = ""
			}
		},
		truckDoor = {
			itemRequired = "truckKey",
			resolveAction = "unanchor",
			consumesItem = true,
			interact = {
				none = "The door to the back of the truck seems to be locked.",
				crowbar = "afjd;law;eraerawf!",
				truckKey = "That did the trick! The door is open now."
			}
		},
		npc1 = {
			interact = {
				none = "Hey man! Welcome to Sideways Town, where you can only walk along a North-South axis!  You uh... you get used to it.",
				crowbar = "Woah dude, cool it!",
				truckKey = "What do you want me to do with that?",
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