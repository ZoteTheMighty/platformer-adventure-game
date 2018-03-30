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
		constructionNpc = "rbxgameasset://Images/construction-worker",
	},
	names = {
		-- characters
		player = "",
		welcomeNpc = "Cookies Guy",
		constructionNpc = "Construction Worker",
		-- items
		crowbar = "Rusty Crowbar",
		truckKey = "Truck Key",
		apples = "Moldy Apples",
		nextMcguffin = "Next McGuffin",
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
			foundMessage = "Many a great journey began with a crowbar...",
		},
		truckKey = {
			icon = "http://www.roblox.com/asset/?id=1391250210",
			cursorIcon = "rbxgameasset://Images/key-cursor",
			foundMessage = "Hey look, someone dropped a key!"
		},
		apples = {
			icon = "http://www.roblox.com/asset/?id=137510460",
			cursorIcon = "rbxgameasset://Images/apple-cursor",
			foundMessage = "Ew... how long have these apples been here..?"
		},
		nextMcguffin = {
			icon = "http://www.roblox.com/asset/?id=1019185679",
			cursorIcon = "rbxgameasset://Images/mcguffin-cursor",
			foundMessage = "Well... I guess I got the Next McGuffin... is this game even finished? (It's not)",
		},
	},
	environment = {
		-- obstacles
		looseBoardScaffolding = {
			itemRequired = "crowbar",
			resolveAction = { type = "unanchor" },
			consumesItem = false,
			interact = {
				none = "That board looks like it could be pried off, if I had the right tool.",
				crowbar = "I managed to pull off the board!",
				truckKey = "I don't see how this key will help me here.",
			}
		},
		truckDoor = {
			itemRequired = "truckKey",
			resolveAction = { type = "unanchor" },
			consumesItem = true,
			interact = {
				none = "The door to the back of the truck seems to be locked.",
				truckKey = "That did the trick! The door is open now.",
			}
		},
		-- flavor interactions
		garbage = {
			interact = {
				none = "Yep, that's a pile of garbage alright.",
				crowbar = "I'm... not gonna hit that garbage with a crowbar.",
				truckKey = "I'm not going to throw this key in a pile of trash, it might be useful!",
				apples = "That probably is where they belong, but I'm going to keep them for now.",
				nextMcguffin = "We don't know what this does yet! Guess I'm stuck here for now...",
			}
		},
		mailbox = {
			interact = {
				none = "I don't have any letters I need to mail.",
				crowbar = "No way! Breaking into a mailbox is a crime!",
				truckKey = "This key is pretty clearly labeled as a \"Truck Key\"  I don't think it'll open a mailbox.",
				apples = "I think you have to get special postage to mail moldy fruit.",
				nextMcguffin = "We don't know what this does yet! Guess I'm stuck here for now...",
			}
		},
		cot = {
			interact = {
				none = "Even if I WAS tired, I wouldn't sleep here.",
				crowbar = "I think that old cot has been through enough.",
				truckKey = "Why do I even still have this key?",
				apples = "Gross, dude, I don't want those.",
				nextMcguffin = "We don't know what this does yet! Guess I'm stuck here for now...",
			}
		},
		-- NPCs
		welcomeNpc = {
			isNpc = true,
			interact = {
				none = "Hey man! Welcome to Sideways Town, where you can only walk along a North-South axis!  You uh... you get used to it.",
				crowbar = "Woah dude, cool it!",
				truckKey = "What do you want me to do with that?",
				apples = "Gross, dude, I don't want those.",
				nextMcguffin = "We don't know what this does yet! Guess you're stuck here for now...",
			}
		},
		constructionNpc = {
			isNpc = true,
			itemRequired = "apples",
			resolveAction = {
				type = "give",
				item = "nextMcguffin",
			},
			consumesItem = true,
			interact = {
				none = "I'm supposed to be cleaning up this place so we can start demolition, but I'm so hungry...",
				crowbar = "That kinda looks like MY crowbar...",
				truckKey = "Hang on, where did you get that?",
				apples = "Hey are those apples? Oooohhh gimme those.  Here, take this thingy.",
				nextMcguffin = "Nah, you can keep it.  I don't even know what it does.",
			}
		},
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