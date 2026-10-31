const is_equal_packs = require("./is_equal_packs")
const types = require("../types")

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

--- Runs a computation in a separate thread, returning a default value until its result is ready.
const function async<T, A...>(s: types.Scope, default: T, compute: Compute<T, A...>, ...: A...): T
	const state = s:once(new_state<<T>>)

	if state.generation == 0 or not is_equal_packs(state.args, ...) then
		if state.generation == 0 then
			state.value = default
		end
		state.generation += 1
		state.args = (table.pack :: any)(...)
		state.done = false
		state.running = true
		task.defer(run, state, state.generation, compute, ...)
	end

	return state.value
end

return async
