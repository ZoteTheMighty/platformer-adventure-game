local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local DataManager = require(ReplicatedStorage.Modules.DataManager)
local NameData = require(ReplicatedStorage.Modules.Data.GameObjectDb).names

local Interactive = {}
Interactive.__index = Interactive

Interactive.ConfigSpec = {
	["Track"] = "IntValue",
	["Range"] = "NumberValue",
	["Object"] = "StringValue",
}

function Interactive.new(model)
	local self = {
		model = model
	}
	setmetatable(self, Interactive)

	local Config = model:FindFirstChild("Config")
	self.rangeSquared = Config:FindFirstChild("Range").Value
	self.track = Config:FindFirstChild("Track").Value
	self.objectId = NameData[Config:FindFirstChild("Object").Value]
	self.inRange = false

	self.selectionBox = Instance.new("SelectionBox", model)
	self.selectionBox.Adornee = model
	self.selectionBox.LineThickness = 0.1
	self.selectionBox.Color3 = Color3.new(0.95,0.9,0)
	self.selectionBox.Visible = false

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

		local prev = self.inRange
		self.inRange = isInteractable(humanoid.RootPart.Position, model.PrimaryPart.Position)
		self.selectionBox.Visible = self.inRange

		if self.inRange ~= prev then
			DataManager.setInClickRange(self.objectId, self.inRange)
		end
	end)

	return self
end

function Interactive:isInRange()
	return self.inRange
end

function Interactive:destroy()
	DataManager.setInClickRange(self.objectId, false)
	self.selectionBox.Visible = false
	self.heartbeatConn:Disconnect()
end

function Interactive:getTrack()
	return self.track
end

return Interactive