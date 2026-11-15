const composites = require("../core/composites")
const primitives = require("../core/primitives")

const function color(c: composites.Compositable, color: Color3): composites.Composite
	const result_primitives = table.create<<primitives.Primitive>>(composites.count_of(c))
	for index, primitive in composites.iter_primitives(c) do
		result_primitives[index] = primitives.with_appearance(primitive, { color = color })
	end
	return table.freeze({ primitives = table.freeze(result_primitives), bounds = c.bounds })
end

return color
