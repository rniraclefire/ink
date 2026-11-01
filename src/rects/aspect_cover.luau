const compat = require("../compat")
const Rect = compat.Rect

--- Returns the smallest rect with the given aspect ratio (width over height) that covers the specified container.
const function aspect_cover(container: Rect, aspect: number, align_x: number?, align_y: number?): Rect
	local w = container.Width
	local h = w / aspect
	if h < container.Height then
		h = container.Height
		w = h * aspect
	end
	const x = container.Min.X + (container.Width - w) * (align_x or 0.5)
	const y = container.Min.Y + (container.Height - h) * (align_y or 0.5)
	return Rect.new(x, y, x + w, y + h)
end

return aspect_cover
