local UserInputService = game:GetService("UserInputService")

local localPlayer = game.Players.LocalPlayer
local character
local humanoid

-- Main control switch for how many (if any) double jumps are available
local maxDoubleJumps = 3

local doubleJumpsLeft = 0

local function onJumpRequest()
	if not character or not humanoid or not character:IsDescendantOf(game.Workspace)
			or humanoid:GetState() == Enum.HumanoidStateType.Dead then
		return
	end

	if doubleJumpsLeft > 0 and humanoid:GetState() == Enum.HumanoidStateType.Freefall then
		doubleJumpsLeft = doubleJumpsLeft - 1
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end

local function characterAdded(newCharacter)
	character = newCharacter
	humanoid = newCharacter:WaitForChild("Humanoid")
	doubleJumpsLeft = 0

	humanoid.StateChanged:connect(function(old, new)
		if new == Enum.HumanoidStateType.Landed then
			doubleJumpsLeft = maxDoubleJumps
		end
	end)
end

if localPlayer.Character then
	characterAdded(localPlayer.Character)
end

localPlayer.CharacterAdded:connect(characterAdded)
UserInputService.JumpRequest:connect(onJumpRequest)

return nil -- Module only needs to run