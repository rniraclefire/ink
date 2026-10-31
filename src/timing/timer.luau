local scope = require("../state/scope")

--- Returns the time elapsed since the timer's key was first requested.
const function timer(s: scope.Scope)
	const elapsed = s:get(0) + s:dt()
	s:set(elapsed)
	return elapsed
end

return timer
