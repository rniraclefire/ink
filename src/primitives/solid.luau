const bounds = require("../core/bounds")
const primitives = require("../core/primitives")

const DEFAULT_COLOR = Color3.new(1, 1, 1)
const SOLID_KIND = table.freeze<<primitives.Kind<nil, Frame>>>({
	name = "Solid",
	instance_class = "Frame",
	init = function(instance, write)
		write(instance, "BorderSizePixel", 0)
	end,
	update = function(instance, _, appearance, write)
		write(instance, "BackgroundColor3", appearance.color or DEFAULT_COLOR)
		write(instance, "BackgroundTransparency", appearance.transparency or 0)
	end,
})

const function solid(b: bounds.Bounds, color: Color3?, transparency: number?): primitives.Primitive
	return primitives.new(SOLID_KIND, b, nil, { color = color, transparency = transparency })
end

return solid
