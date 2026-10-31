local intersect_rects = require("../rects/intersect_rects")
local types = require("../types")

--- Restricts a composite's visible area to a rect, discarding anything entirely outside it.
const function clip(composite: types.Composite, bounds: Rect): types.Composite
	const out_primitives = {}
	for _, primitive in composite.primitives do
		const region = if primitive.clip then intersect_rects(primitive.clip, bounds) else bounds
		const visible = intersect_rects(primitive.bounds, region)
		if visible.Width > 0 and visible.Height > 0 then
			const cloned = table.clone(primitive)
			cloned.clip = region
			table.insert(out_primitives, cloned)
		end
	end
	return { primitives = out_primitives, bounds = bounds }
end

return clip
