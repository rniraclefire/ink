local inset_rect_xy = require("../rects/inset_rect_xy")
local types = require("../types")

--- Grows a composite's bounds by separate horizontal and vertical amounts, without moving its contents.
const function pad_xy(composite: types.Composite, x: number?, y: number?)
	const out = table.clone(composite)
	out.bounds = inset_rect_xy(composite.bounds, -(x or 0), -(y or 0))
	return out
end

return pad_xy
