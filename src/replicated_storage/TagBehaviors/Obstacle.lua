local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

 local DataManager = require(ReplicatedStorage.Modules.DataManager)

local EnvData = require(ReplicatedStorage.Modules.Data.GameObjectDb).environment
local ItemData = require(ReplicatedStorage.Modules.Data.GameObjectDb).items

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

	return self
end

function Obstacle:onClick()
	local selectedItem = DataManager.getSelectedItem()
	local isNpc = EnvData[self.objectId].isNpc
	if isNpc then
		DataManager.showDialogue(self.objectId, EnvData[self.objectId].interact[selectedItem])
	else
		DataManager.showDialogue("player", EnvData[self.objectId].interact[selectedItem])
	end

	local itemRequired = EnvData[self.objectId].itemRequired
	local consumesItem = EnvData[self.objectId].consumesItem
	local resolveAction = EnvData[self.objectId].resolveAction

	-- If this object can be resolved with an item, attempt to do so
	if itemRequired and itemRequired == selectedItem then
		-- Consume the item if necessary
		if consumesItem then
			DataManager.consumeItem(selectedItem)
		end
		-- Resolve the obstacle
		if resolveAction.type == "unanchor" then
			self.model.PrimaryPart.Anchored = false
			CollectionService:RemoveTag(self.model, "Interactive")
		elseif resolveAction.type == "give" then
			-- We should wait so that the message can be read
			wait(3)
			DataManager.addItem(resolveAction.item)
			DataManager.showDialogue("player", ItemData[resolveAction.item].foundMessage)
		end
	end
end

function Obstacle:destroy()
	-- No additional cleanup required
end

return Obstacle