--- Creates a rect of the given size at the origin.
const function rect_sized(width: number, height: number): Rect
	return Rect.new(Vector2.zero, Vector2.new(width, height))
end

return rect_sized
