local UserInputService = game:GetService("UserInputService")

local localPlayer = game.Players.LocalPlayer

local function characterAdded(newCharacter)
	local humanoid = newCharacter:WaitForChild("Humanoid")
	
	humanoid.JumpPower = 70
	humanoid.WalkSpeed = 26
end

if localPlayer.Character then
	characterAdded(localPlayer.Character)
end

localPlayer.CharacterAdded:connect(characterAdded)