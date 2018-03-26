-- State tracker for convenience
local Players = game:GetService("Players")
local humanoid = nil

local function characterAdded(newCharacter)
	humanoid = newCharacter:WaitForChild("Humanoid")

	humanoid.StateChanged:connect(function(old, new)
		print(new.Name)
	end)
end

Players.LocalPlayer.CharacterAdded:connect(characterAdded)

return nil -- Module only needs to run