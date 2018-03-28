local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Immutable = require(ReplicatedStorage.Modules.Util.Immutable)

local PuzzleTools = {}
PuzzleTools.__index = PuzzleTools

function PuzzleTools.reducer(state, action)
	state = state or {
		crowbar = false,
		stepLadder = false,
		universalRemote = false,
	}

	if action.type == "PickupTool" then
		return Immutable.Set(state, action.tool, true)
	end

	return state
end

return PuzzleTools