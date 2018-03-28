local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Roact)
local RoactRodux = require(ReplicatedStorage.RoactRodux)

local ContextBar = Roact.Component:extend("ContextBar")

function ContextBar:render()
	local itemsInRange = self.props.itemsInRange

	local itemsString = ""
	for k, _ in pairs(itemsInRange) do
		itemsString = itemsString .. k .. ", "
	end
	-- local itemsString = table.concat(itemsInRange, ", ")

	return Roact.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.new(0.6, 0, 0.05, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
	}, {
		Roact.createElement("TextLabel", {
			Position = UDim2.new(0.5, 0, 0.5, 0),
			TextSize = 40,
			Font = Enum.Font.Cartoon,
			Text = itemsString,
		})
	})
end

ContextBar = RoactRodux.connect(function(store, props)
	local state = store:getState().interaction

	return {
		itemsInRange = state.nearbyObjects
	}
end)(ContextBar)

return ContextBar