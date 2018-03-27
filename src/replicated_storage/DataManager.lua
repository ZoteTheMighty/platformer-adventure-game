local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rodux = require(ReplicatedStorage.Rodux)

local PuzzleTools = require(ReplicatedStorage.Modules.Data.PuzzleTools)
local Progression = require(ReplicatedStorage.Modules.Data.Progression)

local DataManager = {}
DataManager.__index = DataManager

function DataManager.reducer(state, action)
	state = state or {}

	return {
		tools = PuzzleTools.reducer(state.tools, action),
		progression = Progression.reducer(state.progression, action),
	}
end

DataManager.store = Rodux.Store.new(DataManager.reducer)

function DataManager.addItem(item)
	DataManager.store:dispatch({
		type = "PickupItem",
		item = item,
	})
end

return DataManager