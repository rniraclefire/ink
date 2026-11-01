local types = require("../types")

const compat = require("../compat")
const Enum, Rect, Vector2 = compat.Enum, compat.Rect, compat.Vector2

export type HitState = {
	state: Enum.GuiState,
	clicked: boolean,
	wheel: number,
	drag: Vector2,
	pointer: Vector2,
}

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
	const hotspot = s:once(new_hotspot)
	const primitive: types.Primitive = {
		bounds = bounds,
		hotspot = hotspot,
		hotspot_wheel = options ~= nil and options.wheel == true,
	}
	return hotspot, { primitives = { primitive }, bounds = bounds }
end

return hotspot
