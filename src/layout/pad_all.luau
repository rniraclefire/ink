local inset_rect = require("../rects/inset_rect")
local types = require("../types")

--- Expands the layout bounding box outward by `amount` pixels on all sides without altering primitive positions.
--- Positive values expand bounds; negative values shrink bounds.
const function pad(composite: types.Composite, amount: number)
	const out = table.clone(composite)
	out.bounds = inset_rect(composite.bounds, -amount)
	return out
end

return pad
