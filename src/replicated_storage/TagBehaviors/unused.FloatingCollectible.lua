local RunService = game:GetService("RunService")

local FloatingCollectible = {}
FloatingCollectible.__index = FloatingCollectible

FloatingCollectible.ConfigSpec = {}

function FloatingCollectible.new(model)
	local self = {}
	self.model = model
	self.collectibleName = 'Floating' .. self.model.Name

	local height = 1.5 / 60
	local speed = 2
	local time = math.random(4) * (math.pi / 4.0) -- start with a randomized offset, for fun

	local function updatePosition(dt)
		time = time + dt
		local offset = Vector3.new(0, height * math.sin(speed * time), 0)
		self.model:SetPrimaryPartCFrame(self.model:GetPrimaryPartCFrame() + offset)
	end

	RunService:BindToRenderStep(self.collectibleName,
		Enum.RenderPriority.Character.Value, updatePosition)

	return self
end

function FloatingCollectible:destroy()
	RunService:UnbindFromRenderStep(self.collectibleName)
end

return FloatingCollectible