local MovingPlatform = {}

function MovingPlatform.loop(model, delayTime)
	local platform = model:FindFirstChild("MovingPlatform")

	if not platform then
		error "Bad model state"
	end

	local alignStart = platform:FindFirstChild("AlignStart")
	local alignEnd = platform:FindFirstChild("AlignEnd")
	
	if not alignStart or not alignEnd then
		error "Bad model state"
	end
	
	local force = platform:FindFirstChild("AntiGravityForce")
	if force then
		force.Force = Vector3.new(0, platform:GetMass() * workspace.Gravity, 0)
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