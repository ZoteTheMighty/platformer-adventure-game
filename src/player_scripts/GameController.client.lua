-- Master Control Script for in-game logic
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Debug modules
-- require(ReplicatedStorage.Modules.Util.PlayerStateTracker)
-- require(ReplicatedStorage.Modules.Util.CheckConfigSpec)

-- Connect movement adjustment logic
require(ReplicatedStorage.Modules.Player.DoubleJump)
require(ReplicatedStorage.Modules.Player.MovementAdjuster)
require(ReplicatedStorage.Modules.Player.MouseManager)

-- Ensure that objects have their tag behaviors bound
require(ReplicatedStorage.Modules.TagBindings)