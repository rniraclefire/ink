const compose = require("../composites/compose")
const types = require("../types")
const translate = require("./translate")

--- Stacks composites vertically from top to bottom with an optional `gap` between items.
--- Positions elements sequentially along Y starting from `composites[1].bounds.Min.Y`, leaving X offsets untouched.
const function v_stack(composites: { types.Composite }, gap: number?): types.Composite
	gap = gap or 0
	const placed = table.create<<types.Composite>>(#composites)
	local y = if composites[1] then composites[1].bounds.Min.Y else 0
	for index, c in composites do
		placed[index] = translate(c, 0, y - c.bounds.Min.Y)
		y += c.bounds.Height + gap
	end
	return compose(placed)
end

return v_stack
