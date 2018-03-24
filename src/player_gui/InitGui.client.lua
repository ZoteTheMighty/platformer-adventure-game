local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.Roact)
local Rodux = require(ReplicatedStorage.Rodux)
local RoactRodux = require(ReplicatedStorage.RoactRodux)

local Reducer = require(ReplicatedStorage.Modules.Reducer)
local Inventory = require(ReplicatedStorage.Modules.Components.Inventory)

local store = Rodux.Store.new(Reducer)

local app = Roact.createElement(RoactRodux.StoreProvider, {
	store = store,
}, {
	App = Roact.createElement(Inventory)
})

local function addItem(item)
	store:dispatch({
		type = "AddInventoryItem",
		item = item,
	})
end

Roact.reify(app, Players.LocalPlayer.PlayerGui, "Inventory")

for _ = 1, 5 do
	wait(1)
	addItem({
		name = "hammer",
		url = "http://www.roblox.com/asset/?id=91063296"
	})
end