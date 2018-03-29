local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Binder = require(ReplicatedStorage.Modules.Util.Binder)

local AdvanceTile = require(ReplicatedStorage.Modules.TagBehaviors.AdvanceTile)
local BouncyAwning = require(ReplicatedStorage.Modules.TagBehaviors.BouncyAwning)
local Interactive = require(ReplicatedStorage.Modules.TagBehaviors.Interactive)
local CollectibleItem = require(ReplicatedStorage.Modules.TagBehaviors.CollectibleItem)
local Obstacle = require(ReplicatedStorage.Modules.TagBehaviors.Obstacle)
local NPC = require(ReplicatedStorage.Modules.TagBehaviors.NPC)

local TagBindings = {
	AdvanceTile = Binder.new("AdvanceTile", AdvanceTile),
	BouncyAwning = Binder.new("BouncyAwning", BouncyAwning),
	Interactive = Binder.new("Interactive", Interactive),
	CollectibleItem = Binder.new("CollectibleItem", CollectibleItem),
	Obstacle = Binder.new("Obstacle", Obstacle),
	NPC = Binder.new("NPC", NPC),
}

return TagBindings