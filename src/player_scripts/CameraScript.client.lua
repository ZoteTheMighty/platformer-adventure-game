-- local CollectionService = game:GetService("CollectionService")

local offset = Vector3.new(-30, 5, 0)
local fov = 70
local player = script.Parent.Parent

local camera = game.Workspace.CurrentCamera
local runService = game:GetService("RunService")

local modelTransparencies = {}

camera.FieldOfView = fov

local function modifyTransparency(model, multiplier)
	for _, child in ipairs(model:GetChildren()) do

		-- If part, adjust transparency property
		if child:IsA("BasePart") then
			local alpha = 1.0 - child.Transparency
			child.Transparency = 1.0 - (alpha * multiplier)
		else
			modifyTransparency(child, multiplier)
		end
	end
end

local function findTransparencyGroup(obj)
	while obj.Parent do
		if obj.Name == "TransparencyGroup" then
			return obj
		end
		obj = obj.Parent
	end
	return nil
end

local function updateTransparency(camPos, playerPos)
	-- Restore transparency
	for model in pairs(modelTransparencies) do
		modifyTransparency(model, 1.0 / 0.3)
		modelTransparencies[model] = nil
	end

	-- Find parts in the way
	local ray = Ray.new(camPos, playerPos - camPos)
	local ignoreList = {}

	local count = 0
	while count < 10 do
		local part = game.Workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
		if not part or part.Parent:FindFirstChild("Humanoid") then
			break
		end
		local model = findTransparencyGroup(part)
		if model then
			modelTransparencies[model] = true
		end
		table.insert(ignoreList, part)
	end

	-- Set transparency for parts in list
	for model in pairs(modelTransparencies) do
		modifyTransparency(model, 0.3)
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