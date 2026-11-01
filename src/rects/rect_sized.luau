const compat = require("../compat")
const Rect, Vector2 = compat.Rect, compat.Vector2

--- Creates a rect of the given size at the origin.
const function rect_sized(width: number, height: number): Rect
	return Rect.new(Vector2.zero, Vector2.new(width, height))
end

return rect_sized
