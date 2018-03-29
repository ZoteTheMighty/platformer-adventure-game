local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Immutable = require(ReplicatedStorage.Modules.Util.Immutable)

local Progression = {}
Progression.__index = Progression

function Progression.reducer(state, action)
	state = state or {
		trackId = 1,
		gameStep = 1,
	}

	if action.type == "Advance" then
		return Immutable.JoinDictionaries(state, {
			trackId = action.track,
			gameStep = state.gameStep + 1,
		})
	end

	return state
end

return Progression