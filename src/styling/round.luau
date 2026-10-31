local types = require("../types")

--- Rounds the corners of every primitive in a composite.
const function round(c: types.Composite, amount: number | types.RoundStyle): types.Composite
	const new_primitives = table.create<<types.Primitive>>(#c.primitives)
	const round: types.RoundStyle = type(amount) == "table" and amount
		or { tl = amount, tr = amount, bl = amount, br = amount }
	for index, primitive in c.primitives do
		primitive = table.clone(primitive)
		primitive.round = round
		new_primitives[index] = primitive
	end
	return { primitives = new_primitives, bounds = c.bounds }
end

return round
