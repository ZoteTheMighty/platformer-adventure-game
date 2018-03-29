local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rodux = require(ReplicatedStorage.Rodux)

local Items = require(ReplicatedStorage.Modules.Data.Items)
local Progression = require(ReplicatedStorage.Modules.Data.Progression)
local Interaction = require(ReplicatedStorage.Modules.Data.Interaction)
local Dialogue = require(ReplicatedStorage.Modules.Data.Dialogue)

local DataManager = {}
DataManager.__index = DataManager

function DataManager.reducer(state, action)
	state = state or {}

	return {
		items = Items.reducer(state.items, action),
		progression = Progression.reducer(state.progression, action),
		interaction = Interaction.reducer(state.interaction, action),
		dialogue = Dialogue.reducer(state.dialogue, action),
	}
end

DataManager.store = Rodux.Store.new(DataManager.reducer)

function DataManager.addItem(item)
	DataManager.store:dispatch({
		type = "PickupItem",
		item = item,
	})
end

function DataManager.consumeItem(item)
	DataManager.store:dispatch({
		type = "consumeItem",
		item = item,
	})
end

function DataManager.setInClickRange(object, isInRange)
	if isInRange then
		DataManager.store:dispatch({
			type = "ObjectEnterRange",
			object = object,
		})
	else
		DataManager.store:dispatch({
			type = "ObjectExitRange",
			object = object,
		})
	end
end

function DataManager.getTrack()
	return DataManager.store:getState().progression.trackId
end

function DataManager.updateTrack(track)
	DataManager.store:dispatch({
		type = "Advance",
		track = track,
	})
end

-- UI state events
function DataManager.isInventoryOpen()
	return DataManager.store:getState().interaction.inventoryOpen
end

function DataManager.toggleInventory()
	local currentState = DataManager.isInventoryOpen()
	DataManager.store:dispatch({
		type = "InventoryOpen",
		isOpen = not currentState,
	})
end

function DataManager.selectItem(item)
	DataManager.store:dispatch({
		type = "ItemSelectionChanged",
		item = item,
	})
end

function DataManager.getSelectedItem()
	return DataManager.store:getState().interaction.selectedItem
end

function DataManager.showDialogue(character, message)
	DataManager.store:dispatch({
		type = "ShowDialogue",
		character = character,
		message = message,
	})
end

function DataManager.hideDialogue(character, message)
	DataManager.showDialogue(nil, "")
end

return DataManager