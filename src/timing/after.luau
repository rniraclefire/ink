local types = require("../types")

type AfterState = { elasped: number, duration: number }

const function new_state(): AfterState
	return { elasped = 0, duration = 0 }
end

--- Returns true after the specified duration of seconds has elapsed.
const function after(s: types.Scope, duration: number)
	const state = s:once(new_state)
	if state.duration ~= duration then
		state.duration = duration
		state.elasped = 0
	elseif state.elasped >= state.duration then
		return true
	end
	state.elasped += s:dt()
	return false
end

return after
