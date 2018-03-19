local offset = Vector3.new(-30, 5, 0)
local fov = 90
local player = script.Parent.Parent

local camera = game.Workspace.CurrentCamera
local runService = game:GetService("RunService")

camera.FieldOfView = fov

local function onRenderStep()
	if player.Character then
		local humanoid = player.Character:FindFirstChild("HumanoidRootPart")
		if humanoid then 
			local playerPosition = player.Character.HumanoidRootPart.Position
			local cameraPosition = playerPosition + offset
		
			camera.CoordinateFrame = CFrame.new(cameraPosition, playerPosition)
		end
	end
end

runService:BindToRenderStep('Camera', Enum.RenderPriority.Camera.Value, onRenderStep)