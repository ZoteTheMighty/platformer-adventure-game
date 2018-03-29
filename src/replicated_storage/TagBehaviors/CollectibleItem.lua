local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataManager = require(ReplicatedStorage.Modules.DataManager)

local CollectibleItem = {}
CollectibleItem.__index = CollectibleItem

CollectibleItem.ConfigSpec = {
	["Object"] = "StringValue",
}

function CollectibleItem.new(model)
	local self = {
		model = model
	}
	setmetatable(self, CollectibleItem)

	self.item = model:FindFirstChild("Config"):FindFirstChild("Object").Value

	return self
end

function CollectibleItem:onClick()
	DataManager.addItem(self.item)
	self.model:Destroy()
end

function CollectibleItem:destroy()
	-- No additional cleanup required
end

return CollectibleItem