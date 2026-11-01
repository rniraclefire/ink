const compat = require("../compat")
const Rect = compat.Rect

--- Returns the smallest rect containing both rects.
const function union_rects(a: Rect?, b: Rect): Rect
	return a and Rect.new(a.Min:Min(b.Min), a.Max:Max(b.Max)) or b
end

return union_rects
