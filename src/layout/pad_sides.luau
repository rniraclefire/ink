local inset_rect_sides = require("../rects/inset_rect_sides")
local types = require("../types")

--- Grows a composite's bounds by a separate amount on each side, without moving its contents.
const function pad_sides(composite: types.Composite, top: number?, left: number?, bottom: number?, right: number?)
	const out = table.clone(composite)
	out.bounds = inset_rect_sides(composite.bounds, -(top or 0), -(left or 0), -(bottom or 0), -(right or 0))
	return out
end

return pad_sides
