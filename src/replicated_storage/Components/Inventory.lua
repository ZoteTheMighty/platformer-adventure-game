local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Roact)
local RoactRodux = require(ReplicatedStorage.RoactRodux)
local DataManager = require(ReplicatedStorage.Modules.DataManager)

local Item = require(ReplicatedStorage.Modules.Components.Item)

local ItemData = require(ReplicatedStorage.Modules.Data.GameObjectDb).items

local Inventory = Roact.Component:extend("Inventory")

local function getItemDrawer(availableItems, pos)
	local elements = {}
	local count = 0
	for id, _ in pairs(ItemData) do
		if availableItems[id] then
			count = count+1
			elements[count] = Roact.createElement(Item, {
				index = count,
				itemId = id,
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
	local availableItems = self.props.availableItems
	local open = self.props.open

	local toggle = Roact.createElement("ImageButton", {
		Size = UDim2.new(0, 120, 0, 120),
		Position = UDim2.new(0, 20, 0, 20),
		BackgroundTransparency = 1,
		Image = "rbxgameasset://Images/backpack-300px",
		[Roact.Event.MouseButton1Click] = DataManager.toggleInventory,
	})

	if not open then
		return toggle
	end

	local drawer = getItemDrawer(availableItems, UDim2.new(0, 20, 0, 150))

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
	}, { toggle, drawer })
end

Inventory = RoactRodux.connect(function(store, props)
	local state = store:getState()

	return {
		availableItems = state.items,
		open = state.interaction.inventoryOpen,
	}
end)(Inventory)

return Inventory