local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Immutable = require(ReplicatedStorage.Modules.Util.Immutable)

local Interaction = {}
Interaction.__index = Interaction

function Interaction.reducer(state, action)
	state = state or {
		nearbyObjects = {},
		inventoryOpen = false,
		selectedItem = "none",
	}

	if action.type == "ObjectEnterRange" then
		return {
			nearbyObjects = Immutable.Set(state.nearbyObjects, action.object, true),
			selectedItem = state.selectedItem,
			message = state.message,
			inventoryOpen = state.inventoryOpen,
		}
	elseif action.type == "ObjectExitRange" then
		return {
			nearbyObjects = Immutable.RemoveFromDictionary(state.nearbyObjects, action.object),
			selectedItem = state.selectedItem,
			message = state.message,
			inventoryOpen = state.inventoryOpen,
		}
	elseif action.type == "ItemSelectionChanged" then
		return Immutable.Set(state, "selectedItem", action.item)
	elseif action.type == "InventoryOpen" then
		return Immutable.Set(state, "inventoryOpen", action.isOpen)
	end

	return state
end

return Interaction