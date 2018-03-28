local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rodux = require(ReplicatedStorage.Rodux)

local PuzzleTools = require(ReplicatedStorage.Modules.Data.PuzzleTools)
local Progression = require(ReplicatedStorage.Modules.Data.Progression)
local Interaction = require(ReplicatedStorage.Modules.Data.Interaction)

local DataManager = {}
DataManager.__index = DataManager

function DataManager.reducer(state, action)
	state = state or {}

	return {
		tools = PuzzleTools.reducer(state.tools, action),
		progression = Progression.reducer(state.progression, action),
		interaction = Interaction.reducer(state.interaction, action),
	}
end

DataManager.store = Rodux.Store.new(DataManager.reducer)

function DataManager.addItem(item)
	DataManager.store:dispatch({
		type = "PickupItem",
		item = item,
	})
end

function DataManager.selectTool(tool)
	DataManager.store:dispatch({
		type = "ToolSelectionChanged",
		tool = tool,
	})
end

function DataManager.getTrack()
	return DataManager.store:getState().progression.trackId
end

function DataManager.getSelectedTool()
	return DataManager.store:getState().interaction.selectedTool
end

function DataManager.updateTrack(track)
	DataManager.store:dispatch({
		type = "Advance",
		track = track,
	})
end

return DataManager