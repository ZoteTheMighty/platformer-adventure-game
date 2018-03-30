local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local CameraManager = {}

local camera = game.Workspace.CurrentCamera
local modelTransparencies = {}

local OFFSET_Y = 5
local OFFSET_Z = 0
local LOOK_OFFSET_Y = Vector3.new(0, 5, 0)
local SPEED = 2 / 60

local fov = 70
local oldOffset = Vector3.new(-30, OFFSET_Y, OFFSET_Z)
local targetOffset = nil
local transitionAlpha = 0
local player = Players.LocalPlayer

local function modifyTransparency(instance, multiplier)
	-- Apply transparency to parts
	if instance:IsA("BasePart") then
		local alpha = 1.0 - instance.Transparency
		instance.Transparency = 1.0 - (alpha * multiplier)
	end

	-- Apply to any children found
	for _, child in ipairs(instance:GetChildren()) do
		modifyTransparency(child, multiplier)
	end
end

local function findTransparencyGroup(obj)
	while obj.Parent do
		if CollectionService:HasTag(obj, "TransparencyGroup") then
			return obj
		end
		obj = obj.Parent
	end
	return nil
end

local function updateTransparency(camPos, playerPos)
	-- Restore transparency
	for model in pairs(modelTransparencies) do
		modifyTransparency(model, 1.0 / 0.2)
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
		modifyTransparency(model, 0.2)
	end
end

local function onRenderStep()
	local offset = oldOffset
	if targetOffset then
		transitionAlpha = transitionAlpha + SPEED
		offset = oldOffset:Lerp(targetOffset, transitionAlpha)
		if transitionAlpha >= 1 then
			oldOffset = targetOffset
			targetOffset = nil
			transitionAlpha = 0
		end
	end
	if player.Character then
		local humanoid = player.Character:FindFirstChild("HumanoidRootPart")
		if humanoid then
			local playerPosition = player.Character.HumanoidRootPart.Position + LOOK_OFFSET_Y
			local cameraPosition = playerPosition + offset

			camera.CoordinateFrame = CFrame.new(cameraPosition, playerPosition)
			updateTransparency(cameraPosition, playerPosition)
		end
	end
end

-- Public API
function CameraManager.updateOffset(xOffset, newFov)
	targetOffset = Vector3.new(xOffset, OFFSET_Y, OFFSET_Z)
	transitionAlpha = 0
	fov = newFov or fov
	camera.FieldOfView = fov
end

camera.FieldOfView = fov
RunService:BindToRenderStep('Camera', Enum.RenderPriority.Camera.Value, onRenderStep)

return CameraManager