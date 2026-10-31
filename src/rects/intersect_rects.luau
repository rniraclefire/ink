--- Returns the overlap of two rects.
const function intersect_rects(a: Rect, b: Rect)
	const min = a.Min:Max(b.Min)
	const max = a.Max:Min(b.Max):Max(min)
	return Rect.new(min, max)
end

return intersect_rects
