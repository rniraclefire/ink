const translate_into = require("./translate_into")
const types = require("../types")

--- Arranges composites left to right, optionally aligning them within the tallest one.
const function h_stack(composites: { types.Composite }, gap: number?, align: number?): types.Composite
	const spacing = gap or 0
	const count = #composites
	if count == 0 then
		return { primitives = {}, bounds = Rect.new() }
	end

	local top, row_height = math.huge, 0
	if align then
		for _, c in composites do
			top = math.min(top, c.bounds.Min.Y)
			row_height = math.max(row_height, c.bounds.Height)
		end
	end

	const primitives = {}
	const start_x = composites[1].bounds.Min.X
	local x = start_x
	local min_y, max_y = math.huge, -math.huge

	for _, c in composites do
		const b = c.bounds
		const dy = if align then top + (row_height - b.Height) * align - b.Min.Y else 0
		translate_into(c, x - b.Min.X, dy, primitives)

		min_y = math.min(min_y, b.Min.Y + dy)
		max_y = math.max(max_y, b.Max.Y + dy)
		x += b.Width + spacing
	end

	return { primitives = primitives, bounds = Rect.new(start_x, min_y, x - spacing, max_y) }
end

return h_stack
