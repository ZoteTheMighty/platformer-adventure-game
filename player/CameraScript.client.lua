local offset = Vector3.new(-30, 5, 0)
local fov = 90
local player = script.Parent.Parent

local camera = game.Workspace.CurrentCamera
local runService = game:GetService("RunService")

local transparentParts = {}

camera.FieldOfView = fov

local function updateTransparency(camPos, playerPos)
	-- Restore transparency
	for k,v in pairs(transparentParts) do
		k.Transparency = v
		transparentParts[k] = nil
	end

	-- Find parts in the way
	local ray = Ray.new(camPos, playerPos - camPos)
	local ignoreList = {}

	local count = 0
	while count < 10 do
		local part = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
		if not part or part.Parent:FindFirstChild("Humanoid") then
			break
		end
		transparentParts[part] = part.Transparency
		table.insert(ignoreList, part)
	end

	-- Set transparency for parts in list
	for k,v in pairs(transparentParts) do
		k.Transparency = 0.7
	end
end

local function onRenderStep()
	if player.Character then
		local humanoid = player.Character:FindFirstChild("HumanoidRootPart")
		if humanoid then 
			local playerPosition = player.Character.HumanoidRootPart.Position
			local cameraPosition = playerPosition + offset
		
			camera.CoordinateFrame = CFrame.new(cameraPosition, playerPosition)
 			updateTransparency(cameraPosition, playerPosition)
 		end
	end
end

runService:BindToRenderStep('Camera', Enum.RenderPriority.Camera.Value, onRenderStep)