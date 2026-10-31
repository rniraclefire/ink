--- Returns whether two optional Rects have the same position and size.
const function is_equal_rects(a: Rect?, b: Rect?): boolean
	if a == nil or b == nil then
		return a == b
	end
	return a.Min == b.Min and a.Max == b.Max
end

return is_equal_rects
