local ReplicatedStorage = game:GetService("ReplicatedStorage")

 local DataManager = require(ReplicatedStorage.Modules.DataManager)

local EnvData = require(ReplicatedStorage.Modules.Data.GameObjectDb).environment

local NPC = {}
NPC.__index = NPC

NPC.ConfigSpec = {
	["Object"] = "StringValue",
}

function NPC.new(model)
	local self = {
		model = model
	}
	setmetatable(self, NPC)

	self.objectId = model:FindFirstChild("Config"):FindFirstChild("Object").Value

	return self
end

function NPC:onClick()
	local item = DataManager.getSelectedItem()
	local message = EnvData[self.objectId].interact[item]
	if message then
		DataManager.showDialogue(self.objectId, message)
	end
end

function NPC:destroy()
	-- No additional cleanup required
end

return NPC