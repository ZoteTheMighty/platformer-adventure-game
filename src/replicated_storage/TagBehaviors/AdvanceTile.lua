local GameConstants = require(game.ReplicatedStorage.Modules.GameConstants)
local DataManager = require(game.ReplicatedStorage.Modules.DataManager)
local debounce = require(game.ReplicatedStorage.Modules.Util.Debounce)

local AdvanceTile = {}
AdvanceTile.__index = AdvanceTile

AdvanceTile.ConfigSpec = {
	["SourceTrack"] = "IntValue",
	["DestTrack"] = "IntValue",
}

function AdvanceTile.new(model)
	local self = {
		model = model
	}
	setmetatable(self, AdvanceTile)

	self.sourceTrack = model:FindFirstChild("Config"):FindFirstChild("SourceTrack").Value
	self.destTrack = model:FindFirstChild("Config"):FindFirstChild("DestTrack").Value

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
		DataManager.updateTrack(self.destTrack)
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

function AdvanceTile:getSourceTrack()
	return self.sourceTrack
end

function AdvanceTile:getDestTrack()
	return self.destTrack
end

function AdvanceTile:destroy()
	self.touchedConn:Disconnect()
end

return AdvanceTile