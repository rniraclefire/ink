local is_equal_packs = require("./is_equal_packs")
local types = require("../types")

type State<T> = {
	args: types.Pack,
	value: types.Pack,
	first_computed: boolean,
}

const function new_state<T>(): State<T>
	return { args = { n = 0 }, value = { n = 0 }, first_computed = false }
end

--- Caches a computation's results, recomputing only when its arguments change.
const function expensive<A..., R...>(s: types.Scope, compute: (s: types.Scope, A...) -> R..., ...: A...): R...
	const state = s:once(new_state)

	const skip_recompute = state.first_computed and is_equal_packs(state.args, ...)
	if skip_recompute then
		return table.unpack<<any>>(state.value, 1, state.value.n)
	end

	state.args = (table.pack :: any)(...)
	state.value = (table.pack :: any)(compute(s, ...))
	state.first_computed = true

	return table.unpack<<any>>(state.value, 1, state.value.n)
end

return expensive
