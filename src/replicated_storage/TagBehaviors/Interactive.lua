local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local DataManager = require(ReplicatedStorage.Modules.DataManager)

local Interactive = {}
Interactive.__index = Interactive

Interactive.ConfigSpec = {
	["Track"] = "IntValue",
	["Range"] = "NumberValue",
}

function Interactive.new(model)
	local self = {
		model = model
	}
	setmetatable(self, Interactive)

	self.rangeSquared = model:FindFirstChild("Config"):FindFirstChild("Range").Value
	self.track = model:FindFirstChild("Config"):FindFirstChild("Track").Value

	self.selectionBox = Instance.new("SelectionBox", model)
	self.selectionBox.Adornee = model
	self.selectionBox.LineThickness = 0.1
	self.selectionBox.Color3 = Color3.new(0.95,0.9,0)
	self.selectionBox.Visible = true

	local player = Players.LocalPlayer

	local function isInteractable(a, b)
		local z = b.Z - a.Z
		local y = b.Y - a.Y
		local onTrack = (self.track == DataManager.getTrack())
		return onTrack and (z * z + y * y) < self.rangeSquared
	end

	self.heartbeatConn = RunService.Heartbeat:Connect(function()
		local character = player.Character
		if not character then return end
		local humanoid = character.Humanoid
		if not humanoid then return end

		self.selectionBox.Visible = isInteractable(humanoid.RootPart.Position, model.PrimaryPart.Position)
	end)

	return self
end

function Interactive:isInRange()
	return self.selectionBox.Visible
end

function Interactive:destroy()
	self.heartbeatConn:Disconnect()
end

function Interactive:getTrack()
	return self.track
end

return Interactive