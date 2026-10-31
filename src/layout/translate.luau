const types = require("../types")

--- Moves a composite by a pixel offset.
const function translate(composite: types.Composite, x: number?, y: number?): types.Composite
	const offset = Vector2.new(x, y)
	const out_primitives = table.create<<primitives.Primitive>>(#composite.primitives)
	for _, primitive in composite.primitives do
		primitive = table.clone(primitive)
		primitive.bounds = Rect.new(primitive.bounds.Min + offset, primitive.bounds.Max + offset)
		primitive.clip = primitive.clip and Rect.new(primitive.clip.Min + offset, primitive.clip.Max + offset)
		table.insert(out_primitives, primitive)
	end
	return {
		primitives = out_primitives,
		bounds = Rect.new(composite.bounds.Min + offset, composite.bounds.Max + offset),
	}
end

return translate
