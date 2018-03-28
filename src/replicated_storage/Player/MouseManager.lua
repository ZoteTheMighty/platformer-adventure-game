local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

local TagBindings = require(ReplicatedStorage.Modules.TagBindings)
local DataManager = require(ReplicatedStorage.Modules.DataManager)

local Camera = game.Workspace.CurrentCamera
local Mouse = Players.LocalPlayer:GetMouse()

local MouseManager = {}
MouseManager.__index = MouseManager

local function mouseClick()
	local ray = Camera:ScreenPointToRay(Mouse.X, Mouse.Y, 1)
	ray = Ray.new(ray.Origin, ray.Direction * 1000)

	-- Get all valid parts
	local validParts = {}
	local partToTagHolder = {}
	local currentTrack = DataManager.getTrack()
	for _, object in pairs(CollectionService:GetTagged(TagBindings.Interactive.tagName)) do
		local interactive = TagBindings.Interactive:get(object)
		local part = nil
		if object:IsA("BasePart") then
			part = object
		elseif object:IsA("Model") then
			part = object.PrimaryPart
		end
		if part and interactive then
			if interactive:isInRange() and interactive:getTrack() == currentTrack then
				validParts[#validParts+1] = part
				partToTagHolder[part] = object
			end
		end
	end

	-- Grab clicked part with tag
	local clickedPart = game.Workspace:FindPartOnRayWithWhitelist(ray, validParts)

	-- Process click according to tag behaviors
	local tagHolder = partToTagHolder[clickedPart]
	if (CollectionService:HasTag(tagHolder, TagBindings.CollectibleTool.tagName)) then
		TagBindings.CollectibleTool:get(tagHolder):onClick()
	end
end

Mouse.Button1Down:Connect(mouseClick)

return MouseManager