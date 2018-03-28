local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Binder = require(ReplicatedStorage.Modules.Util.Binder)

local AdvanceTile = require(ReplicatedStorage.Modules.TagBehaviors.AdvanceTile)
local BouncyAwning = require(ReplicatedStorage.Modules.TagBehaviors.BouncyAwning)
local Interactive = require(ReplicatedStorage.Modules.TagBehaviors.Interactive)
local CollectibleTool = require(ReplicatedStorage.Modules.TagBehaviors.CollectibleTool)

local TagBindings = {
	AdvanceTile = Binder.new("AdvanceTile", AdvanceTile),
	BouncyAwning = Binder.new("BouncyAwning", BouncyAwning),
	Interactive = Binder.new("Interactive", Interactive),
	CollectibleTool = Binder.new("CollectibleTool", CollectibleTool),
}

return TagBindings