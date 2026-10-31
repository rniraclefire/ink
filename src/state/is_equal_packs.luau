local types = require("../types")

const function is_equal_packs<T>(stored: types.Pack<T>, ...: T): boolean
	const n = select("#", ...)
	if stored.n ~= n then
		return false
	end
	for i = 1, n do
		if stored[i] ~= select(i, ...) then
			return false
		end
	end
	return true
end

return is_equal_packs
