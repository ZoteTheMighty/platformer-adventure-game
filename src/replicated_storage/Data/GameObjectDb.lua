local Players = game:GetService("Players")

local GameObjectDb = {
	tracks = {
		[1] = {
			zoom = -30,
		},
		[2] = {
			zoom = -35,
		},
		[3] = {
			zoom = -20,
		}
	},
	icons = {
		player = "",
		welcomeNpc = "rbxgameasset://Images/cookies-guy",
		constructionNpc = "",
	},
	names = {
		-- characters
		player = "",
		welcomeNpc = "Cookies Guy",
		constructionNpc = "",
		-- items
		crowbar = "Rusty Crowbar",
		truckKey = "Truck Key",
		apples = "Moldy Apples",
		-- environment
		looseBoardScaffolding = "Loose Board",
		truckDoor = "Truck Back Door",
		garbage = "Pile of Garbage",
		mailbox = "Mailbox",
		cot = "Old Cot",
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
		apples = {
			icon = "",
			cursorIcon = "",
			foundMessage = "Ew... how long have these apples been here..?"
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
				truckKey = "I don't see how this key will help me here.",
			}
		},
		truckDoor = {
			itemRequired = "truckKey",
			resolveAction = "unanchor",
			consumesItem = true,
			interact = {
				none = "The door to the back of the truck seems to be locked.",
				crowbar = "Wait... how are you doing this..?",
				truckKey = "That did the trick! The door is open now.",
			}
		},
		welcomeNpc = {
			interact = {
				none = "Hey man! Welcome to Sideways Town, where you can only walk along a North-South axis!  You uh... you get used to it.",
				crowbar = "Woah dude, cool it!",
				truckKey = "What do you want me to do with that?",
				apples = "Gross, dude, I don't want those.",
			}
		},
		garbage = {
			interact = {
				none = "Yep, that's a pile of garbage alright.",
				crowbar = "I'm... not gonna hit that garbage with a crowbar.",
				truckKey = "I'm not going to throw this key in a pile of trash, it might be useful!",
				apples = "Gross, dude, I don't want those.",
			}
		},
		mailbox = {
			interact = {
				none = "I don't have any letters I need to mail.",
				crowbar = "No way! Breaking into a mailbox is a crime!",
				truckKey = "This key is pretty clearly labeled as a \"Truck Key\"  I don't think it'll open a mailbox.",
				apples = "Gross, dude, I don't want those.",
			}
		},
		constructionNpc = {
			interact = {
				none = "Even if I WAS tired, I wouldn't sleep here.",
				crowbar = "That kinda looks like MY crowbar...",
				truckKey = "Hang on, where did you get that?",
				apples = "Gross, dude, I don't want those.",
			}
		},
		cot = {
			interact = {
				none = "Even if I WAS tired, I wouldn't sleep here.",
				crowbar = "I think that old cot has been through enough.",
				truckKey = "Why do I even still have this key?",
				apples = "Gross, dude, I don't want those.",
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