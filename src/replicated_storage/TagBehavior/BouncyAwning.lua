local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local GameConstants = require(ReplicatedStorage.Modules.GameConstants)
local adjustedPower = GameConstants.JUMP_POWER * 1.4

local BouncyAwning = {}
BouncyAwning.__index = BouncyAwning

local function getJumpReset(humanoid)
	return function(oldState, newState)
		if newState == Enum.HumanoidStateType.Freefall then
			humanoid.JumpPower = GameConstants.JUMP_POWER
		end
	end
end

function BouncyAwning.new(model)
	local self = {}
	self.model = model
	local AwningGeometry = model:FindFirstChild("AwningGeometry")

	self.touchedConn = AwningGeometry.Touched:Connect(function(other)
		local player = game.Players:GetPlayerFromCharacter(other.Parent)
		if player then
			local humanoid = player.Character.Humanoid
			humanoid.JumpPower = adjustedPower
			humanoid.Jump = true
		end
	end)

	return self
end

function BouncyAwning:destroy()
	self.touchedConn:Disconnect()
end

-- Stitch up the jump reset functionality - this should only run once
local localPlayer = Players.LocalPlayer

local function characterAdded(newCharacter)
	local humanoid = newCharacter:WaitForChild("Humanoid")
	humanoid.StateChanged:connect(getJumpReset(humanoid))
end

if localPlayer.Character then
	characterAdded(localPlayer.Character)
end

localPlayer.CharacterAdded:connect(characterAdded)

return BouncyAwning