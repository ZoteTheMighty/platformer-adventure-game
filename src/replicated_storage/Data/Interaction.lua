local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Immutable = require(ReplicatedStorage.Modules.Util.Immutable)

local Interaction = {}
Interaction.__index = Interaction

function Interaction.reducer(state, action)
	state = state or {
		nearbyObjects = {},
		selectedTool = nil,
	}

	if action.type == "ObjectEnterRange" then
		return {
			nearbyObjects = Immutable.Set(state.nearbyObjects, action.item, true),
			selectedTool = state.selectedTool
		}
	elseif action.type == "ObjectExitRange" then
		return {
			nearbyObjects = Immutable.RemoveFromDictionary(state.nearbyObjects, action.item),
			selectedTool = state.selectedTool
		}
	elseif action.type == "ToolSelectionChanged" then
		return Immutable.Set(state, "selectedTool", action.tool)
	end

	return state
end

return Interaction