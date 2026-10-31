--- Creates a rect from a position and size.
const function rect(x: number, y: number, width: number, height: number): Rect
	return Rect.new(Vector2.new(x, y), Vector2.new(x + width, y + height))
end

return rect
