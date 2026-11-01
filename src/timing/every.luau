local types = require("../types")

type AfterState = {
	elasped: number,
	duration: number,
}

const function new_state(): AfterState
	return { elasped = 0, duration = 0 }
end

--- Returns true each time another interval of the specified duration in seconds has elapsed.
const function every(s: types.Scope, duration: number)
	const state = s:once(new_state)
	if state.duration ~= duration then
		state.duration = duration
		state.elasped = 0
	end
	state.elasped += s:dt()
	if state.elasped >= state.duration then
		state.elasped -= state.duration
		return true
	end
	return false
end

return every
