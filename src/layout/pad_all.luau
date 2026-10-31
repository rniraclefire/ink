local inset_rect = require("../rects/inset_rect")
local types = require("../types")

--- Grows a composite's bounds by the same amount on every side, without moving its contents.
const function pad(composite: types.Composite, amount: number)
	const out = table.clone(composite)
	out.bounds = inset_rect(composite.bounds, -amount)
	return out
end

return pad
