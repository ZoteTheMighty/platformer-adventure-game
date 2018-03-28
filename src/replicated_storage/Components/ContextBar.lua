local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Roact)

local ContextBar = Roact.Component:extend("ContextBar")

function ContextBar:render()

	return Roact.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.new(0.6, 0, 0.05, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
	}, {
		Roact.createElement("TextLabel", {
			Text = "Here's where you'd see some stuff"
		})
	})
end

return ContextBar