local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.Roact)
local RoactRodux = require(ReplicatedStorage.RoactRodux)

local DataManager = require(ReplicatedStorage.Modules.DataManager)
local HUD = require(ReplicatedStorage.Modules.Components.HUD)

local app = Roact.createElement(RoactRodux.StoreProvider, {
	store = DataManager.store,
}, {
	App = Roact.createElement(HUD)
})

Roact.reify(app, Players.LocalPlayer.PlayerGui, "HUD")

game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)