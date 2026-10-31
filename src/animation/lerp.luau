const lerp_types = require("./datatypes/lerp_types")

--- Interpolates between two values of the same type.
const function lerp<T>(initial: T, goal: T, alpha: number): T
	const initial_kind, goal_type = typeof(initial), typeof(goal)
	if initial_kind == goal_type then
		const lerp_type = lerp_types[initial_kind]
		return lerp_type(initial, initial, alpha) or error(`Cannot lerp a {initial_kind}`)
	else
		error(`Cannot lerp an initial {initial_kind} with a goal {goal_type}`)
	end
end

return lerp
