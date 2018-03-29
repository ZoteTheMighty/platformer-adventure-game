local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Roact)
local RoactRodux = require(ReplicatedStorage.RoactRodux)

local DataManager = require(ReplicatedStorage.Modules.DataManager)

local Data = require(ReplicatedStorage.Modules.Data.GameObjectDb)

local DialogueBar = Roact.Component:extend("DialogueBar")

function DialogueBar:render()
	local character = self.props.character
	local message = self.props.message

	if not character or not message then
		return nil
	end

	local characterIcon = Roact.createElement("ImageLabel", {
		AnchorPoint = Vector2.new(0, 0),
		Image = Data.icons[character],
		Position = UDim2.new(0, 10, 0, 10),
		Size = UDim2.new(0, 180, 0, 180),
	})

	local characterName = Roact.createElement("TextLabel", {
		Font = Enum.Font.Cartoon,
		Position = UDim2.new(0.5, 0, 0, 20),
		Text = Data.names[character],
		TextColor3 = Color3.new(0.9, 0.9, 0.9),
		TextSize = 32,
	})

	local messageBody = Roact.createElement("TextLabel", {
		AnchorPoint = Vector2.new(0, 0),
		BackgroundTransparency = 1,
		Font = Enum.Font.Cartoon,
		Position = UDim2.new(0, 200, 0, 52),
		Size = UDim2.new(1, -210, 1, -72),
		Text = message,
		TextColor3 = Color3.new(0.9, 0.9, 0.9),
		TextSize = 28,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
	})

	return Roact.createElement("ImageButton", {
		AnchorPoint = Vector2.new(0, 1),
		AutoButtonColor = false,
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.7,
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, 200),
		[Roact.Event.MouseButton1Click] = function()
			DataManager.hideDialogue()
		end,
	}, { characterName, characterIcon, messageBody })
end

DialogueBar = RoactRodux.connect(function(store, props)
	local state = store:getState()

	return {
		character = state.dialogue.character,
		message = state.dialogue.message,
	}
end)(DialogueBar)

return DialogueBar