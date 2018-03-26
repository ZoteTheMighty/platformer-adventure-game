local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Immutable = require(ReplicatedStorage.Modules.Util.Immutable)

local function inventoryReducer(state, action)
	state = state or {
		items = {},
	}

	if action.type == "AddInventoryItem" then
		return {
			items = Immutable.Append(state.items, action.item)
		}
	end

	return state
end

local function progressionReducer(state, action)
	state = state or {
		trackId = 1,
		itemsFound = 0,
	}

	if action.type == "NextTrack" then
		return {
			trackId = state.trackId + 1,
			itemsFound = state.itemsFound,
		}
	elseif action.type == "FoundItem" then
		return {
			trackId = state.trackId,
			itemsFound = state.itemsFound + 1,
		}
	end

	return state
end

local function reducer(state, action)
	state = state or {}

	return {
		inventory = inventoryReducer(state.inventory, action),
		progression = progressionReducer(state.progression, action),
	}
end

return reducer