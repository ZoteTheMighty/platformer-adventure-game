local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Immutable = require(ReplicatedStorage.Modules.Util.Immutable)

local Items = {}
Items.__index = Items

function Items.reducer(state, action)
	state = state or {
		crowbar = false,
		truckKey = false,
	}

	if action.type == "PickupItem" then
		return Immutable.Set(state, action.item, true)
	elseif action.type == "ConsumeItem" then
		return Immutable.Set(state, action.item, false)
	end

	return state
end

return Items