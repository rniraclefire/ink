local TextService = game:GetService("TextService")

local types = require("../types")

local size_cache: { [string]: Vector2 } = {}

--- Creates a composite containing measured text.
const function text(content: string, style: types.TextStyle, max_width: number?): types.Composite
	const width = max_width or math.huge
	const cache_key = `{content}\0{style.size}\0{style.font.Value}\0{width}`
	local size = size_cache[cache_key]
	if not size then
		size = TextService:GetTextSize(content, style.size, style.font, Vector2.new(width, math.huge))
		size_cache[cache_key] = size
	end
	const bounds = Rect.new(Vector2.zero, size)

	const primitive: types.Primitive = {
		bounds = bounds,
		text = content,
		text_style = style,
	}

	return { primitives = { primitive }, bounds = bounds }
end

return text
