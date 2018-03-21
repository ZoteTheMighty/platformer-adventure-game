local UserInputService = game:GetService("UserInputService")

local localPlayer = game.Players.LocalPlayer
local GameConstants = require(game.ReplicatedStorage.GameConstants)

local function characterAdded(newCharacter)
	local humanoid = newCharacter:WaitForChild("Humanoid")
	
	humanoid.JumpPower = GameConstants.JUMP_POWER
	humanoid.WalkSpeed = GameConstants.WALK_SPEED
	humanoid.MaxSlopeAngle = GameConstants.MAX_SLOPE_ANGLE
end

if localPlayer.Character then
	characterAdded(localPlayer.Character)
end

localPlayer.CharacterAdded:connect(characterAdded)