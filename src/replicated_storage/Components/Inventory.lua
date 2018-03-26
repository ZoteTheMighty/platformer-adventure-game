local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Roact)
local RoactRodux = require(ReplicatedStorage.RoactRodux)

local Item = require(ReplicatedStorage.Modules.Components.Item)

local Inventory = Roact.Component:extend("Inventory")

function Inventory:render()
	local items = self.props.items
	local elements = {}
	local itemCount = #items

	for i, v in ipairs(items) do
		elements[i] = Roact.createElement(Item, {
			index = i,
			item = v,
			width = 1.0 / itemCount
		})
	end

	return Roact.createElement("ScreenGui", {}, {
		Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(0, 120*itemCount, 0, 120),
			Position = UDim2.new(0.5, 0, 0.9, 0),
			BackgroundTransparency = 1
		}, elements)
	})
end

Inventory = RoactRodux.connect(function(store, props)
	local state = store:getState()
	local inventory = state.inventory

	return {
		items = inventory.items
	}
end)(Inventory)

return Inventory