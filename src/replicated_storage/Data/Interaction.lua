local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Immutable = require(ReplicatedStorage.Modules.Util.Immutable)

local Interaction = {}
Interaction.__index = Interaction

function Interaction.reducer(state, action)
	state = state or {
		nearbyObjects = {},
		inventoryOpen = false,
		selectedTool = "none",
	}

	if action.type == "ObjectEnterRange" then
		return {
			nearbyObjects = Immutable.Set(state.nearbyObjects, action.object, true),
			selectedTool = state.selectedTool,
			message = state.message,
			inventoryOpen = state.inventoryOpen,
		}
	elseif action.type == "ObjectExitRange" then
		return {
			nearbyObjects = Immutable.RemoveFromDictionary(state.nearbyObjects, action.object),
			selectedTool = state.selectedTool,
			message = state.message,
			inventoryOpen = state.inventoryOpen,
		}
	elseif action.type == "ToolSelectionChanged" then
		return Immutable.Set(state, "selectedTool", action.tool)
	elseif action.type == "InventoryOpen" then
		return Immutable.Set(state, "inventoryOpen", action.isOpen)
	end

	return state
end

return Interaction