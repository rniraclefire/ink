const types = require("../types")

const input_source_intent = {}
input_source_intent.__index = input_source_intent

--[=[
	@class RobloxIntent
	Tracks input events (mouse, touch, wheel, keyboard) from an `IntentSource`
	and maps screen coordinates into local UI space.
]=]
export type RobloxIntent = setmetatable<{
	pending: types.Intent,
	state: types.IntentState,
	to_local: (Vector2) -> Vector2,
	screen_pointer: Vector2,
	last_pointer: Vector2,
	touch: InputObject?,
	connections: { RBXScriptConnection },
}, typeof(input_source_intent)>

const function new_intent(): types.Intent
	return {
		pointer = Vector2.zero,
		pointer_delta = Vector2.zero,
		down = false,
		pressed = false,
		released = false,
		wheel = 0,
		keys_held = {},
		keys_pressed = {},
	}
end

--- Creates a new input intent listener bound to `source`.
--- `to_local` transforms screen Vector2 coordinates to coordinates relative to your root container.
function input_source_intent.new(source: types.IntentSource, to_local: (Vector2) -> Vector2): RobloxIntent
	const self: RobloxIntent = setmetatable(
		{
			pending = new_intent(),
			state = { hotspots = {}, active = nil },
			to_local = to_local,
			screen_pointer = Vector2.zero,
			last_pointer = Vector2.zero,
			touch = nil,
			connections = {},
		},
		input_source_intent
	)

	const pending = self.pending

	const function is_primary(input: InputObject): boolean
		return input.UserInputType == Enum.UserInputType.MouseButton1
			or (input.UserInputType == Enum.UserInputType.Touch and (self.touch == nil or self.touch == input))
	end

	table.insert(
		self.connections,
		source.InputBegan:Connect(function(input)
			if is_primary(input) then
				if input.UserInputType == Enum.UserInputType.Touch then
					self.touch = input
				end
				self.screen_pointer = Vector2.new(input.Position.X, input.Position.Y)
				pending.down = true
				pending.pressed = true
			elseif input.UserInputType == Enum.UserInputType.Keyboard then
				pending.keys_held[input.KeyCode] = true
				pending.keys_pressed[input.KeyCode] = true
			end
		end)
	)

	table.insert(
		self.connections,
		source.InputChanged:Connect(function(input)
			const t = input.UserInputType
			if t == Enum.UserInputType.MouseMovement or (t == Enum.UserInputType.Touch and input == self.touch) then
				self.screen_pointer = Vector2.new(input.Position.X, input.Position.Y)
			elseif t == Enum.UserInputType.MouseWheel then
				pending.wheel += input.Position.Z
			end
		end)
	)

	table.insert(
		self.connections,
		source.InputEnded:Connect(function(input)
			if is_primary(input) then
				self.touch = nil
				pending.down = false
				pending.released = true
			elseif input.UserInputType == Enum.UserInputType.Keyboard then
				pending.keys_held[input.KeyCode] = nil
			end
		end)
	)

	return self
end

--- Takes a snapshot of pending input events accrued since the last frame and resets one-shot flags.
function input_source_intent.take(self: RobloxIntent): types.Intent
	const pending = self.pending
	const pointer = self.to_local(self.screen_pointer)

	pending.pointer = pointer
	pending.pointer_delta = pointer - self.last_pointer
	self.last_pointer = pointer

	const pressed_keys = pending.keys_pressed
	const held_keys = pending.keys_held

	local copy_pressed = {}
	for k, v in pressed_keys do
		copy_pressed[k] = v
	end
	local copy_held = {}
	for k, v in held_keys do
		copy_held[k] = v
	end

	const snapshot: types.Intent = {
		pointer = pending.pointer,
		pointer_delta = pending.pointer_delta,
		down = pending.down,
		pressed = pending.pressed,
		released = pending.released,
		wheel = pending.wheel,
		keys_held = copy_held,
		keys_pressed = copy_pressed,
	}

	pending.pressed = false
	pending.released = false
	pending.wheel = 0
	table.clear(pending.keys_pressed)

	return snapshot
end

--- Registers the rendered composite's hotspots for hit-testing in subsequent frames.
function input_source_intent.commit(self: RobloxIntent, composite: types.Composite)
	const hotspots = self.state.hotspots
	table.clear(hotspots)
	for _, primitive in composite.primitives do
		const hotspot = primitive.hotspot
		if hotspot then
			hotspot.bounds = primitive.bounds
			table.insert(hotspots, primitive)
		end
	end
end

function input_source_intent.destroy(self: RobloxIntent)
	for _, connection in self.connections do
		connection:Disconnect()
	end
	table.clear(self.connections)
	table.clear(self.state.hotspots)
	self.state.active = nil
end

return table.freeze(input_source_intent)
