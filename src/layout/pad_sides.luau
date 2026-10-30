local inset_rect_sides = require("../rects/inset_rect_sides")
local types = require("../types")

--- Expands the layout bounding box outward by distinct side margins without altering primitive positions.
--- Positive values expand bounds; negative values shrink bounds.
const function pad_sides(composite: types.Composite, top: number?, left: number?, bottom: number?, right: number?)
	const out = table.clone(composite)
	out.bounds = inset_rect_sides(composite.bounds, -(top or 0), -(left or 0), -(bottom or 0), -(right or 0))
	return out
end

return pad_sides
