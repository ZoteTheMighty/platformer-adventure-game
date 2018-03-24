local AdvanceArrow = {}

local GameConstants = require(game.ReplicatedStorage.Modules.GameConstants)
local Util = require(game.ReplicatedStorage.Modules.Util)

local function onTouchPlayer(model, otherPart)
	local player = game.Players:GetPlayerFromCharacter(otherPart.Parent)
	if player then
		local Config = model:FindFirstChild("Configuration")
		print("Advance from " .. Config:FindFirstChild("Track").Value)
		AdvanceArrow:AdvanceCharacter(model, player)
	end
end

function AdvanceArrow:Initialize(parent)
	local BasePlate = parent:FindFirstChild("BasePlate")

	BasePlate.Touched:Connect(Util:Debounce(1, function(otherPart)
		onTouchPlayer(parent, otherPart)
	end))
end

function AdvanceArrow:AdvanceCharacter(model, player)
	local MasterControl = require(player.PlayerScripts.ControlScript.MasterControl)
	MasterControl:Disable()

	local NextTrackSensor = model:FindFirstChild("NextTrackSensor")
	local humanoid = player.Character.Humanoid
	humanoid.WalkSpeed = 15
	humanoid:MoveTo(NextTrackSensor.Position)

	-- Wait till we get there, then return control
	humanoid.MoveToFinished:Wait()
	MasterControl:Enable()
	humanoid.WalkSpeed = GameConstants.WALK_SPEED
end

return AdvanceArrow