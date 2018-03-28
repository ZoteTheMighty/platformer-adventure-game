local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Roact)
local RoactRodux = require(ReplicatedStorage.RoactRodux)

local ContextBar = Roact.Component:extend("ContextBar")

function ContextBar:render()
	local objectsInRange = self.props.objectsInRange
	local children = {}

	local objectList = {}
	for k, _ in pairs(objectsInRange) do
		objectList[#objectList+1] = k
	end
	local objectsString = table.concat(objectList, ", ")
	if string.len(objectsString) > 0 then
		children = {
			Roact.createElement("TextLabel", {
				Position = UDim2.new(0.5, 0, 0.5, 0),
				TextSize = 40,
				TextColor3 = Color3.new(0.95,0.9,0),
				Font = Enum.Font.Cartoon,
				Text = objectsString,
			})
		}
	end

	return Roact.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.new(0.6, 0, 0.05, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.6,
	}, children)
end

ContextBar = RoactRodux.connect(function(store, props)
	local state = store:getState().interaction

	return {
		objectsInRange = state.nearbyObjects
	}
end)(ContextBar)

return ContextBar