const compose = require("../composites/compose")
const types = require("../types")
const translate = require("./translate")

--- Stacks composites horizontally from left to right with an optional `gap` between items.
--- Positions elements sequentially along X starting from `composites[1].bounds.Min.X`, leaving Y offsets untouched.
const function h_stack(composites: { types.Composite }, gap: number?): types.Composite
	gap = gap or 0
	const placed = table.create<<types.Composite>>(#composites)
	local x = if composites[1] then composites[1].bounds.Min.X else 0
	for index, c in composites do
		placed[index] = translate(c, x - c.bounds.Min.X, 0)
		x += c.bounds.Width + gap
	end
	return compose(placed)
end

return h_stack
