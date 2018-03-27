local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TagModules = ReplicatedStorage.Modules.TagBehaviors:GetChildren()

local function isSpecEmpty(spec)
	local count = 0
	for _, _ in pairs(spec) do
		count = count + 1
	end
	return count == 0
end

local function checkInstance(mod, spec, tagged)
	local config = tagged:FindFirstChild("Config")
	if config then
		-- Check for presence of each tag
		for name, tagType in pairs(spec) do
			local tag = config:FindFirstChild(name)
			if not tag then
				print("WARNING - " .. mod.Name .. " named " .. tagged.Name .. " missing config field " .. name)
			elseif not tag:IsA(tagType) then
				print("WARNING - " .. mod.Name .. " named " .. tagged.Name .. " has config field " .. name
					.. " with improper type - expected " .. tagType .. " but found " .. tag.ClassName)
			end
		end
	elseif not isSpecEmpty(spec) then
		print("WARNING - No config object for " .. mod.Name .. " named " .. tagged.Name)
	end
end

for _, mod in ipairs(TagModules) do
	-- Find the config spec for the tag module
	local spec = require(mod).ConfigSpec
	if spec then
		-- Iterate over all objects that use that tag
		for _, tagged in ipairs(CollectionService:GetTagged(mod.Name)) do
			checkInstance(mod, spec, tagged)
		end
	else
		print("WARNING - No config spec defined for " .. mod.Name)
	end
end

return nil -- Only runs