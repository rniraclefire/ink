const types = require("../types")
const is_equal_packs = require("./is_equal_packs")

type State<T> = {
	args: types.Pack,
	value: T,
	generation: number,
	running: boolean,
	done: boolean,
}

export type Compute<T, A...> = (become: (T) -> (), A...) -> T

const function new_state<T>(): State<T>
	return {
		args = { n = 0 },
		value = nil,
		generation = 0,
		running = false,
		done = false,
	}
end

const function run<T, A...>(state: State<T>, generation: number, compute: Compute<T, A...>, ...: A...)
	const function become(value: T)
		if state.generation == generation then
			state.value = value
		end
	end

	-- TODO better error handling
	const ok, result = pcall(compute, become, ...)

	if state.generation ~= generation then
		return
	end

	state.running = false
	if ok then
		state.value = result
		state.done = true
	else
		task.spawn(error, result, 0)
	end
end

const function pack_into(target: types.Pack, ...: unknown)
	const n = select("#", ...)
	table.clear(target)
	target.n = n
	for i = 1, n do
		target[i] = select(i, ...)
	end
end

const function async<T, A...>(s: types.Scope, default: T, compute: Compute<T, A...>, ...: A...): T
	const state = s:once(new_state) :: State<T>

	if state.generation == 0 or not is_equal_packs(state.args, ...) then
		if state.generation == 0 then
			state.value = default
		end
		state.generation += 1
		pack_into(state.args, ...)
		state.done = false
		state.running = true
		task.defer(run, state, state.generation, compute, ...)
	end

	return state.value
end

return async
