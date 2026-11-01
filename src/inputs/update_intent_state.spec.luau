const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const compat = require("../compat")
const Rect, Vector2, Enum = compat.Rect, compat.Vector2, compat.Enum

const hit_region = require("./hit_region")
const scope = require("../state/scope")
const update_intent_state = require("./update_intent_state")

type Overrides = {
	pointer: Vector2?,
	pointer_delta: Vector2?,
	down: boolean?,
	pressed: boolean?,
	released: boolean?,
	wheel: number?,
}

const function intent(o: Overrides): any
	return {
		pointer = o.pointer or Vector2.zero,
		pointer_delta = o.pointer_delta or Vector2.zero,
		down = o.down or false,
		pressed = o.pressed or false,
		released = o.released or false,
		wheel = o.wheel or 0,
		keys_held = {},
		keys_pressed = {},
	}
end

const function setup(...: { bounds: Rect, wheel: boolean?, clip: Rect? }): (any, { any })
	const s = scope.new()
	const hotspots, states = {}, {}
	for i = 1, select("#", ...) do
		const spec = select(i, ...)
		const hit, region = hit_region(s:key(tostring(i)), spec.bounds, { wheel = spec.wheel })
		const primitive = region.primitives[1]
		primitive.clip = spec.clip
		hit.bounds = spec.bounds
		hotspots[i] = primitive
		states[i] = hit
	end
	return { hotspots = hotspots, active = nil }, states
end

describe("update_intent_state", function()
	it("hovers the hotspot under the pointer", function()
		const state, h = setup({ bounds = Rect.new(0, 0, 10, 10) })
		update_intent_state(state, intent({ pointer = Vector2.new(5, 5) }))
		expect(h[1].state).toBe(Enum.GuiState.Hover)
	end)

	it("leaves hotspots away from the pointer idle", function()
		const state, h = setup({ bounds = Rect.new(0, 0, 10, 10) })
		update_intent_state(state, intent({ pointer = Vector2.new(50, 50) }))
		expect(h[1].state).toBe(Enum.GuiState.Idle)
	end)

	it("only hovers the topmost of overlapping hotspots", function()
		const state, h = setup({ bounds = Rect.new(0, 0, 10, 10) }, { bounds = Rect.new(0, 0, 10, 10) })
		update_intent_state(state, intent({ pointer = Vector2.new(5, 5) }))
		expect(h[1].state).toBe(Enum.GuiState.Idle)
		expect(h[2].state).toBe(Enum.GuiState.Hover)
	end)

	it("presses the hotspot under the pointer", function()
		const state, h = setup({ bounds = Rect.new(0, 0, 10, 10) })
		update_intent_state(state, intent({ pointer = Vector2.new(5, 5), down = true, pressed = true }))
		expect(h[1].state).toBe(Enum.GuiState.Press)
	end)

	it("clicks when pressed and released on the same hotspot", function()
		const state, h = setup({ bounds = Rect.new(0, 0, 10, 10) })
		update_intent_state(state, intent({ pointer = Vector2.new(5, 5), down = true, pressed = true }))
		update_intent_state(state, intent({ pointer = Vector2.new(5, 5), released = true }))
		expect(h[1].clicked).toBe(true)
	end)

	it("clicks on a press and release within one frame", function()
		const state, h = setup({ bounds = Rect.new(0, 0, 10, 10) })
		update_intent_state(state, intent({ pointer = Vector2.new(5, 5), pressed = true, released = true }))
		expect(h[1].clicked).toBe(true)
	end)

	it("doesn't click when released somewhere else", function()
		const state, h = setup({ bounds = Rect.new(0, 0, 10, 10) })
		update_intent_state(state, intent({ pointer = Vector2.new(5, 5), down = true, pressed = true }))
		update_intent_state(state, intent({ pointer = Vector2.new(50, 50), released = true }))
		expect(h[1].clicked).toBe(false)
	end)

	it("only reports a click for one frame", function()
		const state, h = setup({ bounds = Rect.new(0, 0, 10, 10) })
		update_intent_state(state, intent({ pointer = Vector2.new(5, 5), pressed = true, released = true }))
		update_intent_state(state, intent({ pointer = Vector2.new(5, 5) }))
		expect(h[1].clicked).toBe(false)
	end)

	it("stays pressed while dragged off the hotspot", function()
		const state, h = setup({ bounds = Rect.new(0, 0, 10, 10) })
		update_intent_state(state, intent({ pointer = Vector2.new(5, 5), down = true, pressed = true }))
		update_intent_state(state, intent({ pointer = Vector2.new(50, 50), down = true }))
		expect(h[1].state).toBe(Enum.GuiState.Press)
	end)

	it("doesn't hover other hotspots while one is pressed", function()
		const state, h = setup({ bounds = Rect.new(0, 0, 10, 10) }, { bounds = Rect.new(20, 0, 30, 10) })
		update_intent_state(state, intent({ pointer = Vector2.new(5, 5), down = true, pressed = true }))
		update_intent_state(state, intent({ pointer = Vector2.new(25, 5), down = true }))
		expect(h[2].state).toBe(Enum.GuiState.Idle)
	end)

	it("reports pointer movement as drag while pressed", function()
		const state, h = setup({ bounds = Rect.new(0, 0, 10, 10) })
		update_intent_state(state, intent({ pointer = Vector2.new(5, 5), down = true, pressed = true }))
		update_intent_state(
			state,
			intent({ pointer = Vector2.new(8, 9), pointer_delta = Vector2.new(3, 4), down = true })
		)
		expect(h[1].drag.X).toBe(3)
		expect(h[1].drag.Y).toBe(4)
	end)

	it("reports the pointer relative to the hotspot", function()
		const state, h = setup({ bounds = Rect.new(100, 100, 200, 200) })
		update_intent_state(state, intent({ pointer = Vector2.new(130, 140) }))
		expect(h[1].pointer.X).toBe(30)
		expect(h[1].pointer.Y).toBe(40)
	end)

	it("keeps the pointer relative while dragged off the hotspot", function()
		const state, h = setup({ bounds = Rect.new(100, 100, 200, 200) })
		update_intent_state(state, intent({ pointer = Vector2.new(150, 150), down = true, pressed = true }))
		update_intent_state(state, intent({ pointer = Vector2.new(250, 150), down = true }))
		expect(h[1].pointer.X).toBe(150)
		expect(h[1].pointer.Y).toBe(50)
	end)

	it("sends the wheel to the topmost hotspot that captures it", function()
		const state, h = setup(
			{ bounds = Rect.new(0, 0, 100, 100), wheel = true },
			{ bounds = Rect.new(10, 10, 20, 20) }
		)
		update_intent_state(state, intent({ pointer = Vector2.new(15, 15), wheel = 2 }))
		expect(h[1].wheel).toBe(2)
		expect(h[2].wheel).toBe(0)
		expect(h[2].state).toBe(Enum.GuiState.Hover) -- the button still gets the hover
	end)

	it("resets the wheel the next frame", function()
		const state, h = setup({ bounds = Rect.new(0, 0, 100, 100), wheel = true })
		update_intent_state(state, intent({ pointer = Vector2.new(5, 5), wheel = 2 }))
		update_intent_state(state, intent({ pointer = Vector2.new(5, 5) }))
		expect(h[1].wheel).toBe(0)
	end)

	it("ignores the part of a hotspot outside its clip", function()
		const state, h = setup({ bounds = Rect.new(0, 0, 100, 100), clip = Rect.new(0, 0, 50, 50) })
		update_intent_state(state, intent({ pointer = Vector2.new(75, 75) }))
		expect(h[1].state).toBe(Enum.GuiState.Idle)
		update_intent_state(state, intent({ pointer = Vector2.new(25, 25) }))
		expect(h[1].state).toBe(Enum.GuiState.Hover)
	end)
end)

return nil
