const lerp_types = require("./datatypes/lerp_types")

--- Linearly interpolates between `initial` and `goal` by `alpha` (0 to 1).
const function lerp<T>(initial: T, goal: T, alpha: number): T
	const initial_kind, goal_type = typeof(initial), typeof(goal)
	if initial_kind == goal_type then
		const lerp_type = lerp_types[initial_kind] or error(`Cannot lerp a {initial_kind}`)
		return lerp_type(initial, goal, alpha)
	else
		error(`Cannot lerp an initial {initial_kind} with a goal {goal_type}`)
	end
end

return lerp
