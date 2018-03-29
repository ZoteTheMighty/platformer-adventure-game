local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Roact)
local RoactRodux = require(ReplicatedStorage.RoactRodux)
local DataManager = require(ReplicatedStorage.Modules.DataManager)

local Tool = require(ReplicatedStorage.Modules.Components.Tool)

local ToolData = require(ReplicatedStorage.Modules.Data.GameObjectDb).tools

local Inventory = Roact.Component:extend("Inventory")

local function getToolDrawer(availableTools, pos)
	local elements = {}
	local count = 0
	for id, _ in pairs(ToolData) do
		if availableTools[id] then
			count = count+1
			elements[count] = Roact.createElement(Tool, {
				index = count,
				toolId = id,
			})
		end
	end

	if #elements == 0 then
		return nil
	end

	return Roact.createElement("Frame", {
		Size = UDim2.new(0, 120, 0, 130 * count),
		Position = pos,
		BackgroundTransparency = 1
	}, elements)
end

function Inventory:render()
	local availableTools = self.props.availableTools
	local open = self.props.open

	local toggle = Roact.createElement("ImageButton", {
		Size = UDim2.new(0, 120, 0, 120),
		Position = UDim2.new(0, 20, 0, 20),
		BackgroundTransparency = 1,
		Image = "rbxgameasset://Images/bogdanco-Toolkit-300px",
		[Roact.Event.MouseButton1Click] = DataManager.toggleInventory,
	})

	if not open then
		return toggle
	end

	local drawer = getToolDrawer(availableTools, UDim2.new(0, 20, 0, 150))

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
	}, { toggle, drawer })
end

Inventory = RoactRodux.connect(function(store, props)
	local state = store:getState()

	return {
		availableTools = state.tools,
		open = state.interaction.inventoryOpen,
	}
end)(Inventory)

return Inventory