local union_rects = require("../rects/union_rects")
local types = require("../types")

--- Combines multiple composites into a single composite.
--- Primitives are rendered in array order (first-to-last = back-to-front).
--- Overall bounds default to the union of all child composite bounds unless overridden by `bounded_by`.
const function compose(composed_of: { types.Composite }, bounded_by: Rect?): types.Composite
	local total = 0
	for _, c in composed_of do
		total += #c.primitives
	end

	const out_primitives: { types.Primitive } = table.create(total)
	local out_bounds: Rect?
	local cursor = 1
	for _, c in composed_of do
		const count = #c.primitives
		table.move(c.primitives, 1, count, cursor, out_primitives)
		cursor += count
		out_bounds = union_rects(out_bounds, c.bounds)
	end
	return {
		primitives = out_primitives,
		bounds = bounded_by or out_bounds or Rect.new(),
	}
end

return compose
