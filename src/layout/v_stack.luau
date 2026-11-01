const compat = require("../compat")
const Rect = compat.Rect

const translate_into = require("./translate_into")
const types = require("../types")

--- Arranges composites top to bottom, optionally aligning them within the longest one.
const function v_stack(composites: { types.Composite }, gap: number?, align: number?): types.Composite
	const spacing = gap or 0
	const count = #composites
	if count == 0 then
		return { primitives = {}, bounds = Rect.new() }
	end

	local left, column_width = math.huge, 0
	if align then
		for _, c in composites do
			left = math.min(left, c.bounds.Min.X)
			column_width = math.max(column_width, c.bounds.Width)
		end
	end

	const primitives = {}
	const start_y = composites[1].bounds.Min.Y
	local y = start_y
	local min_x, max_x = math.huge, -math.huge

	for _, c in composites do
		const b = c.bounds
		const dx = if align then left + (column_width - b.Width) * align - b.Min.X else 0
		translate_into(c, dx, y - b.Min.Y, primitives)

		min_x = math.min(min_x, b.Min.X + dx)
		max_x = math.max(max_x, b.Max.X + dx)
		y += b.Height + spacing
	end

	return { primitives = primitives, bounds = Rect.new(min_x, start_y, max_x, y - spacing) }
end

return v_stack
