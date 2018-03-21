local Util = {}

function Util:Debounce(delay, func)
	local hasTriggered = false
	return function(...)
		if not hasTriggered then
			hasTriggered = true
			func(...)
			wait(delay)
			hasTriggered = false
		end
	end
end

return Util