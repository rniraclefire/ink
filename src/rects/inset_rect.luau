local inset_rect_sides = require("./inset_rect_sides")

--- Shrinks a rect by the same amount on every side.
const function inset_rect(r: Rect, amount: number)
	return inset_rect_sides(r, amount, amount, amount, amount)
end

return inset_rect
