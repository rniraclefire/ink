local types = require("../types")

export type Hotspot = types.Hotspot

const function new_hotspot(): types.Hotspot
	return {
		state = Enum.GuiState.Idle,
		clicked = false,
		wheel = 0,
		drag = Vector2.zero,
		pointer = Vector2.zero,
		bounds = Rect.new(),
	}
end

--- Creates an invisible interactive region.
const function hotspot(s: types.Scope, bounds: Rect, options: types.HotspotOptions?): (types.Hotspot, types.Composite)
	const spot = s:once(new_hotspot)
	const primitive: types.Primitive = {
		bounds = bounds,
		hotspot = spot,
		hotspot_wheel = options ~= nil and options.wheel == true,
	}
	return spot, { primitives = { primitive }, bounds = bounds }
end

return hotspot
