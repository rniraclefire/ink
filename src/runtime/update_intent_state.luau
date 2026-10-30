local intersect_rects = require("../rects/intersect_rects")
local is_in_rect = require("../rects/is_in_rect")
local types = require("../types")

--- Evaluates pointer and interaction state across registered hotspots from the previous frame.
--- Hit-testing evaluates hotspots in reverse render order (topmost/highest Z-index first)
--- and intersects against any active clip bounds.
--- Updates `hotspot.state` (Idle, Hover, Press), `hotspot.clicked`, `drag`, `pointer`, and `wheel`.
const function update_intent_state(state: types.IntentState, intent: types.Intent)
	for _, primitive in state.hotspots do
		const hotspot = assert(primitive.hotspot, "Missing hotspot")
		hotspot.state = Enum.GuiState.Idle
		hotspot.clicked = false
		hotspot.wheel = 0
		hotspot.drag = Vector2.zero
	end

	local hover, wheel_target = nil, nil
	for i = #state.hotspots, 1, -1 do
		const primitive = state.hotspots[i]
		const bounds = if primitive.clip then intersect_rects(primitive.bounds, primitive.clip) else primitive.bounds
		if is_in_rect(bounds, intent.pointer) then
			if hover == nil then
				hover = primitive
			end
			if wheel_target == nil and primitive.hotspot_wheel then
				wheel_target = primitive
			end
			if hover and wheel_target then
				break
			end
		end
	end

	const hover_hit = hover and hover.hotspot
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
		assert(wheel_target.hotspot, "Missing hotspot").wheel = intent.wheel
	end

	if hover then
		assert(hover.hotspot, "Missing hotspot").pointer = intent.pointer - hover.bounds.Min
	end

	if active and hover_hit ~= active then
		active.pointer = intent.pointer
	end
end

return update_intent_state
