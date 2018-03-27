local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Roact)
local RoactRodux = require(ReplicatedStorage.RoactRodux)

local Item = require(ReplicatedStorage.Modules.Components.Item)

local PuzzleTools = require(ReplicatedStorage.Modules.Data.PuzzleTools)

local Inventory = Roact.Component:extend("Inventory")

function Inventory:render()
	local tools = self.props.tools

	-- build child elements
	local elements = {}
	local count = 1
	for id, data in pairs(PuzzleTools.data()) do
		-- has item
		if tools[id] then
			elements[count] = Roact.createElement(Item, {
				index = count,
				item = data,
			})
			count = count+1
		end
	end

	return Roact.createElement("ScreenGui", {}, {
		Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(0, 120*(count-1), 0, 120),
			Position = UDim2.new(0.5, 0, 0.9, 0),
			BackgroundTransparency = 1
		}, elements)
	})
end

Inventory = RoactRodux.connect(function(store, props)
	local state = store:getState()

	return {
		tools = state.tools
	}
end)(Inventory)

return Inventory