local runService = game:GetService("RunService")
local FloatingObject = {}

local time = 0
local function updatePosition(model, height, speed, dt)
	time = time + dt
	local offset = Vector3.new(0, height * math.sin(speed * time), 0)
	model:SetPrimaryPartCFrame(model:GetPrimaryPartCFrame() + offset)
end

function FloatingObject:new(model, height, speed)
	self.model = model
	self.height = height or 1.5 / 60
	self.speed = speed or 2
	self.__index = self

	runService:BindToRenderStep('Floating' .. self.model.Name, 
		Enum.RenderPriority.Character.Value,
		function(dt)
			updatePosition(self.model, self.height, self.speed, dt)
		end)

	return self
end


return FloatingObject