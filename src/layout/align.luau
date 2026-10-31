const translate = require("./translate")
const types = require("../types")

--- Positions a composite inside a container rect using 0 to 1 anchors for each axis.
const function align(composite: types.Composite, container: Rect, align_x: number?, align_y: number?): types.Composite
	const b = composite.bounds
	const dx = if align_x then container.Min.X + (container.Width - b.Width) * align_x - b.Min.X else 0
	const dy = if align_y then container.Min.Y + (container.Height - b.Height) * align_y - b.Min.Y else 0
	if dx == 0 and dy == 0 then
		return composite
	end
	return translate(composite, dx, dy)
end

return align
