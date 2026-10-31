--- Shrinks a rect by a separate amount on each side.
const function inset_sides(rect: Rect, top: number, left: number, bottom: number, right: number)
	return Rect.new(
		rect.Min.X + left,
		rect.Min.Y + top,
		math.max(rect.Max.X - right, rect.Min.X + left),
		math.max(rect.Max.Y - bottom, rect.Min.Y + top)
	)
end

return inset_sides
