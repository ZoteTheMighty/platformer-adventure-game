local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Roact)
local Inventory = require(ReplicatedStorage.Modules.Components.Inventory)
local ContextBar = require(ReplicatedStorage.Modules.Components.ContextBar)

local HUD = Roact.Component:extend("HUD")

function HUD:render()
	return Roact.createElement("ScreenGui", {}, {
		-- Roact.createElement(ContextBar),
		Roact.createElement(Inventory),
	})
end

return HUD