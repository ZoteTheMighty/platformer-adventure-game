local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Roact)

local ContextBar = require(ReplicatedStorage.Modules.Components.ContextBar)
local Inventory = require(ReplicatedStorage.Modules.Components.Inventory)
local DialogueBar = require(ReplicatedStorage.Modules.Components.DialogueBar)

local HUD = Roact.Component:extend("HUD")

function HUD:render()
	return Roact.createElement("ScreenGui", {}, {
		Roact.createElement(ContextBar),
		Roact.createElement(Inventory),
		Roact.createElement(DialogueBar),
	})
end

return HUD