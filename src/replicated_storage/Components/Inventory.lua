local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Roact)
local RoactRodux = require(ReplicatedStorage.RoactRodux)

local Tool = require(ReplicatedStorage.Modules.Components.Tool)

local NameData = require(ReplicatedStorage.Modules.Data.GameObjectDb).names
local ToolData = require(ReplicatedStorage.Modules.Data.GameObjectDb).tools

local Inventory = Roact.Component:extend("Inventory")

function Inventory:render()
	local tools = self.props.tools

	local elements = {}
	local count = 0
	for id, data in pairs(ToolData) do
		if tools[id] then
			count = count+1
			elements[count] = Roact.createElement(Tool, {
				index = count,
				icon = data.icon,
				name = NameData[id]
			})
		end
	end

	return Roact.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(0, 120*count, 0, 120),
		Position = UDim2.new(0.5, 0, 0.9, 0),
		BackgroundTransparency = 0
	}, elements)
end

Inventory = RoactRodux.connect(function(store, props)
	local state = store:getState()

	return {
		tools = state.tools
	}
end)(Inventory)

return Inventory