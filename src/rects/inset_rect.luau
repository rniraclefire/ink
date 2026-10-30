local inset_rect_sides = require("./inset_rect_sides")

--- Insets a Rect inward by `amount` pixels on all 4 sides. Positive values shrink the Rect.
const function inset_rect(r: Rect, amount: number)
	return inset_rect_sides(r, amount, amount, amount, amount)
end

return inset_rect
