local inset_rect_sides = require("./inset_rect_sides")

--- Insets a Rect inward by `x` and `y` pixels horizontally and vertically. Positive values shrink the Rect.
const function inset_rect_xy(r: Rect, x: number, y: number)
	return inset_rect_sides(r, y, x, y, x)
end

return inset_rect_xy
