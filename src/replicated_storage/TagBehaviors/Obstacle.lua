local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataManager = require(ReplicatedStorage.Modules.DataManager)

local Obstacle = {}
Obstacle.__index = Obstacle

Obstacle.ConfigSpec = {
	["Track"] = "IntValue",
	["ToolRequired"] = "StringValue",
}

function Obstacle.new(model)
	local self = {
		model = model
	}
	setmetatable(self, Obstacle)

	self.toolRequired = model:FindFirstChild("Config"):FindFirstChild("Tool").Value

	return self
end

function Obstacle:onClick()
	DataManager.addItem(self.tool)
	self.model:Destroy()
end

function Obstacle:destroy()
	-- No additional cleanup required
end

return Obstacle