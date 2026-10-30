local inset_rect_xy = require("../rects/inset_rect_xy")
local types = require("../types")

--- Expands the layout bounding box outward by `x` and `y` pixels without altering primitive positions.
--- Positive values expand bounds; negative values shrink bounds.
const function pad_xy(composite: types.Composite, x: number?, y: number?)
	const out = table.clone(composite)
	out.bounds = inset_rect_xy(composite.bounds, -(x or 0), -(y or 0))
	return out
end

return pad_xy
