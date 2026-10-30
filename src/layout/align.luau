const types = require("../types")
const translate = require("./translate")

--- Aligns `composite` within `container` along the X and/or Y axes.
--- `ax` and `ay` specify the normalized alignment factor (e.g. 0 = left/top, 0.5 = center, 1 = right/bottom).
--- Passing `nil` leaves that axis untouched.
const function align(composite: types.Composite, container: Rect, ax: number?, ay: number?): types.Composite
	const b = composite.bounds
	const dx = if ax then container.Min.X + (container.Width - b.Width) * ax - b.Min.X else 0
	const dy = if ay then container.Min.Y + (container.Height - b.Height) * ay - b.Min.Y else 0
	if dx == 0 and dy == 0 then
		return composite
	end
	return translate(composite, dx, dy)
end

return align
