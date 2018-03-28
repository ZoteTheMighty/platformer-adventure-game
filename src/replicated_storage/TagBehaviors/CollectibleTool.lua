local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataManager = require(ReplicatedStorage.Modules.DataManager)

local CollectibleTool = {}
CollectibleTool.__index = CollectibleTool

CollectibleTool.ConfigSpec = {
	["Object"] = "StringValue",
}

function CollectibleTool.new(model)
	local self = {
		model = model
	}
	setmetatable(self, CollectibleTool)

	self.tool = model:FindFirstChild("Config"):FindFirstChild("Object").Value

	return self
end

function CollectibleTool:onClick()
	DataManager.addTool(self.tool)
	self.model:Destroy()
end

function CollectibleTool:destroy()
	-- No additional cleanup required
end

return CollectibleTool