local types = require("../types")
local is_equal_packs = require("./is_equal_packs")

type State<T> = {
	args: types.Pack,
	value: types.Pack,
	first_computed: boolean,
}

const function new_state<T>(): State<T>
	return { args = { n = 0 }, value = { n = 0 }, first_computed = false }
end

const function pack_into(target: types.Pack, ...: unknown)
	const n = select("#", ...)
	table.clear(target)
	target.n = n
	for i = 1, n do
		target[i] = select(i, ...)
	end
end

--- Caches a computation's results, recomputing only when its arguments change by reference equality (`==`).
--- Note: Pass a dedicated child scope (e.g. `scope:key("name")`) so memoized state
--- does not collide with other values in the same scope.
const function expensive<A..., R...>(s: types.Scope, compute: (s: types.Scope, A...) -> R..., ...: A...): R...
	const state = s:once(new_state)

	const skip_recompute = state.first_computed and is_equal_packs(state.args, ...)
	if skip_recompute then
		return table.unpack<<any>>(state.value, 1, state.value.n)
	end

	pack_into(state.args, ...)
	pack_into(state.value, compute(s, ...))
	state.first_computed = true

	return table.unpack<<any>>(state.value, 1, state.value.n)
end

return expensive
