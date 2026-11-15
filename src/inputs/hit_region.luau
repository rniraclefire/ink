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

const ZERO_RECT = Rect.new()

const function new(bounds: Rect, options: types.HitRegionOptions?): types.HitRegion
	const self = {
		bounds = ZERO_RECT,
		state = Enum.GuiState.Idle,
		clicked = false,
		wheel = 0,
		drag = Vector2.zero,
		pointer = Vector2.zero,
	} :: types.HitRegion

	self.primitives = {
		{
			kind = "hit_region",
			bounds = bounds,
			hit_region = self,
			hit_region_wheel = options ~= nil and options.wheel == true,
		},
	}

	return self
end

--- Creates an invisible interactive region.
const function hit_region(s: types.Scope, bounds: Rect, options: types.HitRegionOptions?): types.HitRegion
	const self = s:get<<types.HitRegion?>>(nil) or s:set(new(bounds, options))
	self.bounds = bounds
	const primitive = self.primitives[1]
	primitive.bounds = bounds
	primitive.hit_region_wheel = options ~= nil and options.wheel == true
	return self
end

return hit_region
