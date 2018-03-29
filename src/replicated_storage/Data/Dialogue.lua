local Dialogue = {}
Dialogue.__index = Dialogue

function Dialogue.reducer(state, action)
	state = state or {
		character = nil,
		message = "",
	}

	if action.type == "ShowDialogue" then
		return {
			character = action.character,
			message = action.message,
		}
	end

	return state
end

return Dialogue