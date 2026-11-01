const compat = require("../compat")
const Enum, Vector2 = compat.Enum, compat.Vector2

const intersect_rects = require("../rects/intersect_rects")
const is_in_rect = require("../rects/is_in_rect")
const types = require("../types")

--- Updates hotspot states each frame from the latest input, using last frame's hotspots.
const function update_intent_state(state: types.IntentState, intent: types.Intent)
	for _, primitive in state.hotspots do
		const hit_region = assert(primitive.hit_region, "Missing hit region")
		hit_region.state = Enum.GuiState.Idle
		hit_region.clicked = false
		hit_region.wheel = 0
		hit_region.drag = Vector2.zero
	end

	local hover, wheel_target = nil, nil
	for i = #state.hotspots, 1, -1 do
		const primitive = state.hotspots[i]
		const bounds = if primitive.clip then intersect_rects(primitive.bounds, primitive.clip) else primitive.bounds
		if is_in_rect(bounds, intent.pointer) then
			if hover == nil then
				hover = primitive
			end
			if wheel_target == nil and primitive.hit_region_wheel then
				wheel_target = primitive
			end
			if hover and wheel_target then
				break
			end
		end
	end

	const hover_hit = hover and hover.hit_region
	if intent.pressed then
		state.active = hover_hit
	end

	const active = state.active
	if active then
		active.state = Enum.GuiState.Press
		active.drag = intent.pointer_delta
	elseif hover_hit then
		hover_hit.state = Enum.GuiState.Hover
	end

	if intent.released then
		if active and active == hover_hit then
			active.clicked = true
		end
		state.active = nil
	end

	if wheel_target then
		assert(wheel_target.hit_region, "Missing hit region").wheel = intent.wheel
	end

	if hover then
		assert(hover.hit_region, "Missing hit region").pointer = intent.pointer - hover.bounds.Min
	end

	if active and hover_hit ~= active then
		active.pointer = intent.pointer - active.bounds.Min
	end
end

return update_intent_state
