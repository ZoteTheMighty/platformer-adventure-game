-- This functionality is only partially implemented!!

local MovingPlatform = {}
MovingPlatform.__index = MovingPlatform

function MovingPlatform.loop(model)
	local self = {}
	self.model = model

	local platform = model:FindFirstChild("MovingPlatform")

	local alignStart = platform:FindFirstChild("AlignStart")
	local alignEnd = platform:FindFirstChild("AlignEnd")

	local force = platform:FindFirstChild("AntiGravityForce")
	if force then
		force.Force = Vector3.new(0, platform:GetMass() * game.Workspace.Gravity, 0)
	end

	while true do
		alignStart.Enabled = false
		alignEnd.Enabled = true
		wait(delayTime)
		alignStart.Enabled = true
		alignEnd.Enabled = false
		wait(delayTime)
	end
end

return MovingPlatform