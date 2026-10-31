local types = require("../types")
local union_rects = require("../rects/union_rects")

--- Combines composites into one. Composites are rendered in order, so later composites draw on top.
const function compose(composed_of: { types.Composite }, bounded_by: Rect?): types.Composite
	local out_primitives: { types.Primitive } = {}
	local out_bounds: Rect?
	for _, c in composed_of do
		table.move(c.primitives, 1, #c.primitives, #out_primitives + 1, out_primitives)
		out_bounds = union_rects(out_bounds, c.bounds)
	end
	return {
		primitives = out_primitives,
		bounds = bounded_by or out_bounds or Rect.new(),
	}
end

return compose
