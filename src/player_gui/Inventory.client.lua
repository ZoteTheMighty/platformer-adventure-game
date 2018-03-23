local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.Roact)

local Item = Roact.Component:extend("Item")

local itemList = {}

function Item:render()
	local index = self.props.index
	local color = self.props.color
	local width = self.props.width

	return Roact.createElement("Frame", {
		Size = UDim2.new(width, 0, 1, 0),
		Position = UDim2.new(0, (index - 1) * 125, 0, 0),
		BackgroundColor3 = color,
		ZIndex = 2
	})
end

local Inventory = Roact.Component:extend("Inventory")

function Inventory:init()
	self.running = false
	self.state = {
		items = {},
	}
 end

function Inventory:render()
	local items = self.state.items
	local elements = {}
	local itemCount = #items

	for i, v in ipairs(items) do
		elements[i] = Roact.createElement(Item, {
			index = i,
			color = v,
			width = 1.0 / itemCount
		})
	end

	return Roact.createElement("ScreenGui", {}, {
		Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(0, 120*itemCount, 0, 120),
			Position = UDim2.new(0.5, 0, 0.9, 0),
			BackgroundTransparency = 1
		}, elements)
	})
end

function Inventory:didMount()
	spawn(function()
		self.running = true

		while self.running do
			-- Use 'setState' to update the component and patch the current
			-- state with new properties.
			-- Don't set `state` directly!
			self:setState({
				items = itemList
			})

			wait(1)
		end
	end)
end

Roact.reify(Roact.createElement(Inventory), Players.LocalPlayer.PlayerGui)

-- Can now add to itemList, which I'll probably move at some point