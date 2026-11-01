const compat = require("../compat")
const Rect = compat.Rect

local types = require("../types")

--- Rotates a composite around its centre, or around a given pivot.
const function rotate(c: types.Composite, degrees: number, pivot_x: number?, pivot_y: number?): types.Composite
	const bounds = c.bounds
	const px = pivot_x or (bounds.Min.X + bounds.Max.X) / 2
	const py = pivot_y or (bounds.Min.Y + bounds.Max.Y) / 2
	const radians = math.rad(degrees)
	const cos, sin = math.cos(radians), math.sin(radians)

	const new_primitives = table.create<<types.Primitive>>(#c.primitives)
	for index, primitive in c.primitives do
		const b = primitive.bounds
		const cx, cy = (b.Min.X + b.Max.X) / 2 - px, (b.Min.Y + b.Max.Y) / 2 - py
		const dx = px + cx * cos - cy * sin - (cx + px)
		const dy = py + cx * sin + cy * cos - (cy + py)

		primitive = table.clone(primitive)
		primitive.bounds = Rect.new(b.Min.X + dx, b.Min.Y + dy, b.Max.X + dx, b.Max.Y + dy)
		primitive.rotation = (primitive.rotation or 0) + degrees
		new_primitives[index] = primitive
	end
	return { primitives = new_primitives, bounds = bounds }
end

return rotate
