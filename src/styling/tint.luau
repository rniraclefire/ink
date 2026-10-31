const types = require("../types")

--- Recolors and/or fades every Primitive in a Composite.
const function tint(c: types.Composite, color: Color3?, transparency: number?): types.Composite
	const new_primitives = table.create<<types.Primitive>>(#c.primitives)
	for index, primitive in c.primitives do
		primitive = table.clone(primitive)
		primitive.color = color or primitive.color
		primitive.transparency = transparency or primitive.transparency
		new_primitives[index] = primitive
	end
	return { primitives = new_primitives, bounds = c.bounds }
end

return tint
