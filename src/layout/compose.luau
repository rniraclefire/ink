const bounds = require("../core/bounds")
const composites = require("../core/composites")
const primitives = require("../core/primitives")

const function compose(...: composites.Compositable?): composites.Composite
	const composite_primitives: { primitives.Primitive } = {}
	local composite_bounds: bounds.Bounds

	for index = 1, select("#", ...) do
		const composite = select(index, ...)
		if not composite then
			continue
		end

		for _, primitive in composites.iter_primitives(composite) do
			table.insert(composite_primitives, primitive)
		end

		composite_bounds = if composite_bounds
			then bounds.union(composite_bounds, composite.bounds)
			else composite.bounds
	end

	return table.freeze({
		primitives = table.freeze(composite_primitives),
		bounds = composite_bounds,
	})
end

return compose
