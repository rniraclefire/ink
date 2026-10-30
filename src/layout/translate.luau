const types = require("../types")

const function translate(composite: types.Composite, x: number?, y: number?): types.Composite
	const dx = x or 0
	const dy = y or 0
	if dx == 0 and dy == 0 then
		return composite
	end

	const offset = Vector2.new(dx, dy)
	const count = #composite.primitives
	const out_primitives = table.create(count)
	for i = 1, count do
		local primitive = table.clone(composite.primitives[i])
		primitive.bounds = Rect.new(primitive.bounds.Min + offset, primitive.bounds.Max + offset)
		primitive.clip = primitive.clip and Rect.new(primitive.clip.Min + offset, primitive.clip.Max + offset)
		out_primitives[i] = primitive
	end
	return {
		primitives = out_primitives,
		bounds = Rect.new(composite.bounds.Min + offset, composite.bounds.Max + offset),
	}
end

return translate
