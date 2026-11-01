const compat = require("../compat")
const Rect = compat.Rect

const translate_into = require("./translate_into")
const types = require("../types")

--- Places each composite in whichever column is currently shortest.
const function masonry(
	composites: { types.Composite },
	columns: number,
	column_width: number,
	gap: number
): types.Composite
	if #composites == 0 then
		return { primitives = {}, bounds = Rect.new() }
	end

	const heights = table.create(columns, 0)
	const primitives = {}
	local max_x, max_y = 0, 0

	for _, c in composites do
		local column = 1
		for i = 2, columns do
			if heights[i] < heights[column] then
				column = i
			end
		end

		const b = c.bounds
		const x = (column - 1) * (column_width + gap)
		const y = heights[column]
		translate_into(c, x - b.Min.X, y - b.Min.Y, primitives)

		heights[column] = y + b.Height + gap
		max_x = math.max(max_x, x + b.Width)
		max_y = math.max(max_y, y + b.Height)
	end

	return { primitives = primitives, bounds = Rect.new(0, 0, max_x, max_y) }
end

return masonry
