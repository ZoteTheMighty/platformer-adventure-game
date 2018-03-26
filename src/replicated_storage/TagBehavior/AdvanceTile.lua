local GameConstants = require(game.ReplicatedStorage.Modules.GameConstants)
local debounce = require(game.ReplicatedStorage.Modules.Util.Debounce)

local AdvanceTile = {}
AdvanceTile.__index = AdvanceTile

function AdvanceTile.new(model)
	local self = {
		model = model
	}
	setmetatable(self, AdvanceTile)

	self.track = model:FindFirstChild("Configuration"):FindFirstChild("Track").Value
	print(self.track)

	local BasePlate = model:FindFirstChild("BasePlate")
	local NextTrackSensor = model:FindFirstChild("NextTrackSensor")

	-- private functions
	local function advanceCharacter(player)
		local MasterControl = require(player.PlayerScripts.ControlScript.MasterControl)
		MasterControl:Disable()

		local humanoid = player.Character.Humanoid
		humanoid.WalkSpeed = 15
		humanoid:MoveTo(NextTrackSensor.Position)

		-- Wait till we get there, then return control
		humanoid.MoveToFinished:Wait()
		MasterControl:Enable()
		humanoid.WalkSpeed = GameConstants.WALK_SPEED
	end

	self.touchedConn = BasePlate.Touched:Connect(debounce(1, function(other)
		local player = game.Players:GetPlayerFromCharacter(other.Parent)
		if player then
			advanceCharacter(player)
		end
	end))

	return self
end

function AdvanceTile:getTrack()
	return self.track
end

function AdvanceTile:destroy()
	self.touchedConn:Disconnect()
end

return AdvanceTile