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

const function new_hit_region(): types.HitRegion
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
const function hit_region(
	s: types.Scope,
	bounds: Rect,
	options: types.HitRegionOptions?
): (types.HitRegion, types.Composite)
	const hit = s:once(new_hit_region)
	const primitive: types.Primitive = {
		bounds = bounds,
		hit_region = hit,
		hit_region_wheel = options ~= nil and options.wheel == true,
	}
	return hit, { primitives = { primitive }, bounds = bounds }
end

return hit_region
