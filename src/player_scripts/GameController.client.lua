-- Master Control Script for in-game logic
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Debug modules
-- require(ReplicatedStorage.Modules.Util.PlayerStateTracker)
require(ReplicatedStorage.Modules.Util.CheckConfigSpec)

-- Connect movement adjustment logic
require(ReplicatedStorage.Modules.Player.DoubleJump)
require(ReplicatedStorage.Modules.Player.MovementAdjuster)

-- Bind tagged interactive objects
local Binder = require(ReplicatedStorage.Modules.Binder)
local AdvanceTile = require(ReplicatedStorage.Modules.TagBehaviors.AdvanceTile)
local BouncyAwning = require(ReplicatedStorage.Modules.TagBehaviors.BouncyAwning)
local FloatingCollectible = require(ReplicatedStorage.Modules.TagBehaviors.FloatingCollectible)

Binder.new("AdvanceTile", AdvanceTile)
Binder.new("BouncyAwning", BouncyAwning)
Binder.new("FloatingCollectible", FloatingCollectible)