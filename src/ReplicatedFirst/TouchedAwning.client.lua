local player = game.Players.LocalPlayer
local GameConstants = require(game.ReplicatedStorage.GameConstants)
local adjustedPower = GameConstants.JUMP_POWER * 1.4

function adjustJump(part, limb)
	if part.name == "AwningGeometry" then
		player.Character.Humanoid.JumpPower = adjustedPower
		player.Character.Humanoid.Jump = true
	end
end

function restoreJump(oldState, newState)
	if newState == Enum.HumanoidStateType.Freefall then
		player.Character.Humanoid.JumpPower = GameConstants.JUMP_POWER
	end
end

player.CharacterAdded:connect(function()
	player.Character.Humanoid.Touched:connect(adjustJump)
	player.Character.Humanoid.StateChanged:connect(restoreJump)
end)