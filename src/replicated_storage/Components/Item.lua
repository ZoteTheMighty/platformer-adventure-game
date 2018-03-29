local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Roact)
local DataManager = require(ReplicatedStorage.Modules.DataManager)

local NameData = require(ReplicatedStorage.Modules.Data.GameObjectDb).names
local ItemData = require(ReplicatedStorage.Modules.Data.GameObjectDb).items

local Item = Roact.Component:extend("Item")

function Item:render()
	local index = self.props.index
	local itemId = self.props.itemId

	local imageLabel = Roact.createElement("ImageButton", {
		Position = UDim2.new(0.1, 0, 0.1, 0),
		Size = UDim2.new(0.8, 0, 0.8, 0),
		Image = ItemData[itemId].icon,
		BackgroundTransparency = 1,
		ZIndex = 2,
		[Roact.Event.MouseButton1Click] = function()
			DataManager.selectItem(itemId)
			DataManager.toggleInventory()
		end,
	})
	local textLabel = Roact.createElement("TextLabel", {
		AnchorPoint = Vector2.new(0.5, 1.0),
		Position = UDim2.new(0.5, 0, 1, 0),
		Size = UDim2.new(1, 0, 0.2, 0),
		BackgroundColor3 = Color3.new(0,0,0),
		BackgroundTransparency = 0.5,
		Font = Enum.Font.Cartoon,
		TextColor3 = Color3.new(0.85, 0.85, 0.85),
		TextSize = 18,
		Text = NameData[itemId],
		ZIndex = 3,
	})

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 120),
		Position = UDim2.new(0, 0, 0, (index - 1) * 130),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.7,
	}, { textLabel, imageLabel })
end

return Item