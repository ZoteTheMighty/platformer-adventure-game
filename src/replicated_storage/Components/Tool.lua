local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Roact = require(ReplicatedStorage.Roact)

local Tool = Roact.Component:extend("Tool")

function Tool:render()
	local index = self.props.index
	local icon = self.props.icon
	local name = self.props.name

	local imageLabel = Roact.createElement("ImageLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		Image = icon,
		ZIndex = 2
	})
	local textLabel = Roact.createElement("TextLabel", {
		AnchorPoint = Vector2.new(0.5, 1.0),
		Position = UDim2.new(0.5, 0, 1, 0),
		Size = UDim2.new(1, 0, 0.2, 0),
		BackgroundColor3 = Color3.new(0,0,0),
		BackgroundTransparency = 0.5,
		TextColor3 = Color3.new(0.85,0.85,0.85),
		Text = name,
		ZIndex = 3,
	})

	return Roact.createElement("Frame", {
		Size = UDim2.new(0, 120, 1, 0),
		Position = UDim2.new(0, (index - 1) * 130, 0, 0),
		BackgroundColor3 = Color3.new(0.5, 0.5, 0.5),
		BackgroundTransparency = 0.7,
	}, { textLabel, imageLabel })
end

return Tool