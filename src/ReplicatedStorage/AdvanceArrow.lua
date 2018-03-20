local AdvanceArrow = {}

local LevelTrackManager = require(game.ReplicatedStorage.LevelTrackManager)
local GameConstants = require(game.ReplicatedStorage.GameConstants)

AdvanceArrow.trackId = -1
AdvanceArrow.isActive = false

AdvanceArrow.ArrowModel = nil
AdvanceArrow.NextTrackSensor = nil

local function setChildrenTransparency(model, value)
	for i,v in ipairs(model:GetChildren()) do
		v.Transparency = value
	end
end

local function onTouchPart(part, limb)
	local player = game.Players:GetPlayerFromCharacter(limb.Parent)
	if (part == AdvanceArrow.ArrowModel:FindFirstChild("Base")) then
		-- Only advance the player if they're not already in the process
		if not player.PlayerScripts.ControlScript.Disabled then
			AdvanceArrow:AdvanceCharacter(player)
		end
	end
end

function AdvanceArrow:Initialize(parent, track, active)
	self.ArrowModel = parent:FindFirstChild("Arrow")
	self.NextTrackSensor = parent:FindFirstChild("NextTrackSensor")

	self.trackId = track
	self.isActive = active

	game.Players.PlayerAdded:connect(function(player)
		player.CharacterAdded:connect(function(character)
			character.Humanoid.Touched:connect(onTouchPart)
		end)
	end)
end

function AdvanceArrow:Activate()
	if self.trackId < 0 then
		error("Cannot activate uninitialized AdvanceArrow")
	end
	self.isActive = true
	setChildrenTransparency(self.ArrowModel, 0)
end

function AdvanceArrow:Deactivate()
	self.isActive = false
	setChildrenTransparency(self.ArrowModel, 0.7)
end


function AdvanceArrow:AdvanceCharacter(player)
	if self.isActive then
		local MasterControl = require(player.PlayerScripts.ControlScript.MasterControl)
		MasterControl:Disable()

		local humanoid = player.Character.Humanoid
		humanoid.WalkSpeed = 10
		humanoid:MoveTo(self.NextTrackSensor.Position)
		
		-- Wait till we get there, then return control
		humanoid.MoveToFinished:Wait()
		MasterControl:Enable()
		humanoid.WalkSpeed = GameConstants.WALK_SPEED
	end
end

return AdvanceArrow