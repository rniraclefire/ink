const types = require("../types")
const pack_types = require("./datatypes/pack_types")
const unpack_types = require("./datatypes/unpack_types")
const spring_coefficients = require("./spring_coefficients")

type State<T> = {
	kind: string?,
	target: T,
	goal: { number },
	position: { number },
	velocity: { number },
	resting: boolean,
}

const EPSILON = 1e-4

const function new_state<T>(): State<T>
	return { kind = nil, target = nil, goal = {}, position = {}, velocity = {}, resting = true }
end

const function spring<T>(s: types.Scope, target: T, speed: number?, damping: number?): T
	const state = s:once(new_state) :: State<T>
	const kind = typeof(target)
	const pack, unpack_value = pack_types[kind], unpack_types[kind]
	assert(pack and unpack_value, `Cannot spring a {kind}`)

	if state.kind ~= kind then
		state.kind = kind
		state.target = target
		state.goal = {}
		pack(target, state.goal)
		state.position = table.clone(state.goal)
		state.velocity = table.create(#state.goal, 0)
		state.resting = true
		return target
	end

	if state.target ~= target then
		state.target = target
		pack(target, state.goal)
		state.resting = false
	end

	if state.resting then
		return target
	end

	const pp, pv, vp, vv = spring_coefficients(s:dt(), damping or 1, speed or 10)

	const goal, position, velocity = state.goal, state.position, state.velocity
	local settled = true

	for i = 1, #goal do
		const displacement = position[i] - goal[i]
		const v = velocity[i]

		const new_displacement = displacement * pp + v * pv
		const new_velocity = displacement * vp + v * vv

		position[i] = goal[i] + new_displacement
		velocity[i] = new_velocity

		if math.abs(new_displacement) > EPSILON or math.abs(new_velocity) > EPSILON then
			settled = false
		end
	end

	if settled then
		for i = 1, #goal do
			position[i] = goal[i]
			velocity[i] = 0
		end
		state.resting = true
		return target
	end

	return unpack_value(position)
end

return spring
