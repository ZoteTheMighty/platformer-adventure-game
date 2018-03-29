local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

 local DataManager = require(ReplicatedStorage.Modules.DataManager)

local EnvData = require(ReplicatedStorage.Modules.Data.GameObjectDb).environment

local Obstacle = {}
Obstacle.__index = Obstacle

Obstacle.ConfigSpec = {
	["Object"] = "StringValue",
}

function Obstacle.new(model)
	local self = {
		model = model
	}
	setmetatable(self, Obstacle)

	self.objectId = model:FindFirstChild("Config"):FindFirstChild("Object").Value

	self.toolRequired = EnvData[self.objectId].toolRequired
	self.resolveAction = EnvData[self.objectId].resolveAction

	return self
end

function Obstacle:onClick()
	local tool = DataManager.getSelectedTool()
	DataManager.showDialogue("player", EnvData[self.objectId].use[tool])
	if tool == self.toolRequired then
		-- Resolve the obstacle
		if self.resolveAction == "unanchor" then
			self.model.PrimaryPart.Anchored = false
			CollectionService:RemoveTag(self.model, "Interactive")
		end
	end
end

function Obstacle:destroy()
	-- No additional cleanup required
end

return Obstacle