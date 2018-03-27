local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Immutable = require(ReplicatedStorage.Modules.Util.Immutable)

local PuzzleTools = {}
PuzzleTools.__index = PuzzleTools

local staticData = {
	crowbar = {
		image = "http://www.roblox.com/asset/?id=159050206",
		name = "Crowbar",
	},
	stepLadder = {
		image = "http://www.roblox.com/asset/?id=32328941",
		name = "Step Ladder",
	},
	universalRemote = {
		image = "http://www.roblox.com/asset/?id=1375046522",
		name = "Universal Remote",
	},
}

function PuzzleTools.data()
	return staticData
end

function PuzzleTools.reducer(state, action)
	state = state or {
		crowbar = false,
		stepLadder = false,
		universalRemote = false,
	}

	if action.type == "PickupItem" then
		return Immutable.Set(state, action.item, true)
	end

	return state
end

return PuzzleTools