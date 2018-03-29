local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

local TagBindings = require(ReplicatedStorage.Modules.TagBindings)
local DataManager = require(ReplicatedStorage.Modules.DataManager)

local ToolData = require(ReplicatedStorage.Modules.Data.GameObjectDb).tools

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
	elseif (CollectionService:HasTag(tagHolder, TagBindings.Obstacle.tagName)) then
		TagBindings.Obstacle:get(tagHolder):onClick()
	elseif (CollectionService:HasTag(tagHolder, TagBindings.NPC.tagName)) then
		TagBindings.NPC:get(tagHolder):onClick()
	end

	-- Clear tool selection
	DataManager.selectTool("none")
end

Mouse.Button1Down:Connect(mouseClick)

DataManager.store.changed:connect(function(newState, oldState)
	local newTool = newState.interaction.selectedTool
	if newTool ~= oldState.interaction.selectedTool then
		if newTool == "none" then
			Mouse.Icon = ""
		else
			Mouse.Icon = ToolData[newTool].cursorIcon
		end
	end
end)

return MouseManager