const compat = require("../compat")
const Rect, Vector2 = compat.Rect, compat.Vector2

const types = require("../types")

const function translate_into(c: types.Composite, dx: number, dy: number, out: { types.Primitive })
	const offset = Vector2.new(dx, dy)
	for _, p in c.primitives do
		const moved = table.clone(p)
		moved.bounds = Rect.new(p.bounds.Min + offset, p.bounds.Max + offset)
		if p.clip then
			moved.clip = Rect.new(p.clip.Min + offset, p.clip.Max + offset)
		end
		table.insert(out, moved)
	end
end

return translate_into
