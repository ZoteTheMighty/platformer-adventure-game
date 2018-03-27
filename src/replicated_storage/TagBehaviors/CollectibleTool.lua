local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataManager = require(ReplicatedStorage.Modules.DataManager)

local CollectibleTool = {}
CollectibleTool.__index = CollectibleTool

CollectibleTool.ConfigSpec = {
	["Track"] = "IntValue",
	["Tool"] = "StringValue",
}

function CollectibleTool.new(model)
	local self = {
		model = model
	}
	setmetatable(self, CollectibleTool)

	self.tool = model:FindFirstChild("Config"):FindFirstChild("Tool").Value

	local function onClick(player)
		DataManager.addItem(self.tool)
		self.model:Destroy()
	end
	self.clickDetector = Instance.new("ClickDetector", model)
	self.clickConn = self.clickDetector.MouseClick:Connect(onClick)

	return self
end

function CollectibleTool:destroy()
	print("remove CollectibleTool")
	self.clickConn:Disconnect()
end

return CollectibleTool