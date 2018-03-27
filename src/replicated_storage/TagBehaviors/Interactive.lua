local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Interactive = {}
Interactive.__index = Interactive

Interactive.ConfigSpec = {
	["Track"] = "IntValue",
	["Range"] = "NumberValue",
}

function Interactive.new(model)
	local self = {}

	self.rangeSquared = model:FindFirstChild("Config"):FindFirstChild("Range").Value

	self.selectionBox = Instance.new("SelectionBox", model)
	self.selectionBox.Adornee = model
	self.selectionBox.LineThickness = 0.1
	self.selectionBox.Color3 = Color3.new(0.95,0.9,0)
	self.selectionBox.Visible = true

	local player = Players.LocalPlayer

	local function isInRange(a, b)
		local z = b.Z - a.Z
		local y = b.Y - a.Y
		return (z * z + y * y) < self.rangeSquared
	end

	self.heartbeatConn = RunService.Heartbeat:Connect(function()
		local character = player.Character
		if not character then return end
		local humanoid = character.Humanoid
		if not humanoid then return end

		self.selectionBox.Visible = isInRange(humanoid.RootPart.Position, model.PrimaryPart.Position)
	end)

	return self
end

function Interactive:destroy()
	self.heartbeatConn:Disconnect()
end

return Interactive