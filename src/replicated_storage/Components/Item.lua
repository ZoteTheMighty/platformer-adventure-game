local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Roact = require(ReplicatedStorage.Roact)

local Item = Roact.Component:extend("Item")

function Item:render()
	local index = self.props.index
	local item = self.props.item
	local width = self.props.width

	print("Rendering an item")
	return Roact.createElement("ImageLabel", {
		Size = UDim2.new(width, 0, 1, 0),
		Position = UDim2.new(0, (index - 1) * 125, 0, 0),
		Image = item.url,
		BackgroundColor3 = Color3.new(0.5, 0.5, 0.5),
		BackgroundTransparency = 0.7,
		ZIndex = 2
	})
end

return Item