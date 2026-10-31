local TweenService = game:GetService("TweenService")

local lerp_types = require("./datatypes/lerp_types")
local scope = require("../state/scope")

export type State<T> = {
	kind: string?,
	initial: T,
	goal: T,
	current: T,
	start: number,
}

const function new_state<T>(): State<T>
	return {
		kind = nil,
		initial = nil,
		goal = nil,
		current = nil,
		start = 0,
	}
end

--- Animates towards a target over a fixed duration with easing, restarting from the current value when the target changes.
const function tween<T>(
	s: scope.Scope,
	goal: T,
	duration: number,
	style: Enum.EasingStyle?,
	direction: Enum.EasingDirection?
): T
	const state = s:once(new_state<<T>>)
	const now = s:time()
	const kind = typeof(goal)
	const lerp = lerp_types[kind] or error(`Cannot tween a {kind}`)

	if state.kind ~= kind then
		state.kind, state.initial, state.goal, state.current, state.start = kind, goal, goal, goal, now
		return goal
	end

	if state.goal ~= goal then
		state.initial = state.current
		state.goal = goal
		state.start = now
	end

	const alpha = if duration <= 0 then 1 else math.clamp((now - state.start) / duration, 0, 1)
	if alpha >= 1 then
		state.current = goal
		return goal
	end

	const eased = TweenService:GetValue(alpha, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
	state.current = lerp(state.initial, state.goal, eased)
	return state.current
end

return tween
