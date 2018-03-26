local CollectionService = game:GetService("CollectionService")

local Binder = {}
Binder.__index = Binder

function Binder.new(tagName, class)
	local self = Binder.newDisabled(tagName, class)

	self:enable()

	return self
end

function Binder.newDisabled(tagName, class)
	local self = {
		tagName = tagName,
		class = class,
		instances = {},
	}
	setmetatable(self, Binder)

	return self
end

function Binder:destroy()
	self:disable()
end

function Binder:enable()
	if self.enabled then return end
	self.enabled = true

	for _,inst in pairs(CollectionService:GetTagged(self.tagName)) do
		self:_add(inst)
	end
	self.instanceAddedConn = CollectionService:GetInstanceAddedSignal(self.tagName):Connect(function(inst)
		self:_add(inst)
	end)
	self.instanceRemovedConn = CollectionService:GetInstanceRemovedSignal(self.tagName):Connect(function(inst)
		self:_remove(inst)
	end)
end

function Binder:disable()
	if not self.enabled then return end
	self.enabled = false

	self.instanceAddedConn:Disconnect()
	self.instanceRemovedConn:Disconnect()

	for _,obj in pairs(self.instances) do
		obj:destroy()
	end
	self.instances = {}
end

function Binder:_add(inst)
	if typeof(self.class) == 'function' then
		self.instances[inst] = self.class(inst, self)
	else
		self.instances[inst] = self.class.new(inst, self)
	end
end

function Binder:_remove(inst)
	self.instances[inst]:destroy()
end

function Binder:get(inst)
	return self.instances[inst]
end

return Binder