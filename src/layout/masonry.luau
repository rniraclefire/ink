local compose = require("../composites/compose")
local types = require("../types")
local translate = require("./translate")

const function masonry(composites: { types.Composite }, columns: number, column_width: number, gap: number): types.Composite
	const heights = table.create(columns, 0)
	const placed = table.create<<types.Composite>>(#composites)
	for index, composite in composites do
		local column = 1
		for c = 2, columns do
			if heights[c] < heights[column] then
				column = c
			end
		end
		const x = (column - 1) * (column_width + gap)
		placed[index] = translate(composite, x - composite.bounds.Min.X, heights[column] - composite.bounds.Min.Y)
		heights[column] += composite.bounds.Height + gap
	end
	return compose(placed)
end

return masonry
