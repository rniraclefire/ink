const bounds = require("../core/bounds")
const composites = require("../core/composites")
const primitives = require("../core/primitives")

const function compose_bounded(b: bounds.Bounds, ...: composites.Compositable?): composites.Composite
	const composite_primitives: { primitives.Primitive } = {}

	for index = 1, select("#", ...) do
		const composite = select(index, ...)
		if composite then
			for _, primitive in composites.iter_primitives(composite) do
				table.insert(composite_primitives, primitive)
			end
		end
	end

	return table.freeze({
		primitives = table.freeze(composite_primitives),
		bounds = b,
	})
end

return compose_bounded
