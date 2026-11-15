const composites = require("../core/composites")
const primitives = require("../core/primitives")

const function fade_result(existing: number?, amount: number): number
	return 1 - (1 - (existing or 0)) * (1 - amount)
end

const function fade_modifier<T>(modifier: T?, amount: number): T?
	if modifier == nil then
		return nil
	end
	const copy = table.clone(modifier :: any)
	copy.transparency = fade_result(copy.transparency, amount)
	return table.freeze(copy)
end

const function fade(c: composites.Compositable, amount: number): composites.Composite
	if amount <= 0 then
		return composites.of(c)
	end

	const result_primitives = table.create<<primitives.Primitive>>(composites.count_of(c))
	for index, primitive in composites.iter_primitives(c) do
		primitive = primitives.with_appearance(primitive, {
			transparency = fade_result(primitive.appearance.transparency, amount),
		})

		const m = primitive.modifiers
		if m.stroke or m.shadow then
			primitive = primitives.with_modifiers(primitive, {
				stroke = fade_modifier(m.stroke, amount),
				shadow = fade_modifier(m.shadow, amount),
			})
		end

		result_primitives[index] = primitive
	end

	return table.freeze({ primitives = table.freeze(result_primitives), bounds = c.bounds })
end

return fade
