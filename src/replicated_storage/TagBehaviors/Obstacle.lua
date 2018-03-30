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

	self.itemRequired = EnvData[self.objectId].itemRequired
	self.consumesItem = EnvData[self.objectId].consumesItem
	self.resolveAction = EnvData[self.objectId].resolveAction

	return self
end

function Obstacle:onClick()
	local item = DataManager.getSelectedItem()
	DataManager.showDialogue("player", EnvData[self.objectId].interact[item])

	-- If this object can be resolved with an item, attempt to do so
	if self.itemRequired and self.itemRequired == item then
		-- Consume the item if necessary
		if self.consumesItem then
			DataManager.consumeItem(item)
		end
		-- Resolve the obstacle
		if self.resolveAction == "unanchor" then
			self.model.PrimaryPart.Anchored = false
			CollectionService:RemoveTag(self.model, "Interactive")
		else
			-- If it's not a known action, it's another item you get
			-- We should wait so that the message can be read
			wait(3)
			DataManager.addItem(self.resolveAction)
		end
	end
end

function Obstacle:destroy()
	-- No additional cleanup required
end

return Obstacle