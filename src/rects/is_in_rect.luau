--- Returns whether a point lies inside a Rect.
const function is_in_rect(rect: Rect, point: Vector2): boolean
	return point.X >= rect.Min.X and point.Y >= rect.Min.Y and point.X < rect.Max.X and point.Y < rect.Max.Y
end

return is_in_rect
