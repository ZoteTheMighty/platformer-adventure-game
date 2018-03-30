local Players = game:GetService("Players")

local GameObjectDb = {
	icons = {
		player = "",
		npc1 = "rbxgameasset://Images/cookies-guy",
	},
	names = {
		-- characters
		player = "",
		npc1 = "Cookies Guy",
		-- items
		crowbar = "Rusty Crowbar",
		truckKey = "Truck Key",
		-- environment
		looseBoardScaffolding = "Loose Board",
		truckDoor = "Truck Back Door",
		garbage = "Pile of Garbage",
		mailbox = "Mailbox"
	},
	items = {
		crowbar = {
			icon = "http://www.roblox.com/asset/?id=159050206",
			cursorIcon = "rbxgameasset://Images/crowbar-cursor",
			foundMessage = "Hey, I could probably use this crowbar.",
		},
		truckKey = {
			icon = "http://www.roblox.com/asset/?id=1391250210",
			cursorIcon = "rbxgameasset://Images/key-cursor",
			foundMessage = "Hey look, someone dropped a key!"
		},
	},
	environment = {
		looseBoardScaffolding = {
			itemRequired = "crowbar",
			resolveAction = "unanchor",
			consumesItem = false,
			interact = {
				none = "That board looks like it could be pried off, if I had the right tool.",
				crowbar = "I managed to pull off the board!",
				truckKey = "I don't see how this key will help me here."
			}
		},
		truckDoor = {
			itemRequired = "truckKey",
			resolveAction = "unanchor",
			consumesItem = true,
			interact = {
				none = "The door to the back of the truck seems to be locked.",
				crowbar = "Wait... how are you doing this..?",
				truckKey = "That did the trick! The door is open now."
			}
		},
		garbage = {
			interact = {
				none = "Yep, that's a pile of garbage alright.",
				crowbar = "I'm... not gonna hit that garbage with a crowbar.",
				truckKey = "I'm not going to throw this key in a pile of trash, it might be useful!"
			}
		},
		mailbox = {
			interact = {
				none = "I don't have any letters I need to mail.",
				crowbar = "No way! Breaking into a mailbox is a crime!",
				truckKey = "This key is pretty clearly labeled as a \"Truck Key\"  I don't think it'll open a mailbox."
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