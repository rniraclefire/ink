const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const compat = require("../compat")
const Rect, Enum = compat.Rect, compat.Enum

const hotspot = require("./hotspot")
const scope = require("../state/scope")

describe("hotspot", function()
	const bounds = Rect.new(0, 0, 50, 20)

	it("starts idle and unclicked", function()
		const state = hotspot(scope.new(), bounds)
		expect(state.state).toBe(Enum.GuiState.Idle)
		expect(state.clicked).toBe(false)
		expect(state.wheel).toBe(0)
	end)

	it("returns a composite with one hotspot primitive", function()
		const state, region = hotspot(scope.new(), bounds)
		expect(#region.primitives).toBe(1)
		expect(region.primitives[1].hotspot).toBe(state)
		expect(region.bounds).toBe(bounds)
	end)

	it("keeps the same state while its key is requested", function()
		const s = scope.new()
		const first = hotspot(s:key("h"), bounds)
		s:next(1 / 60)
		expect(hotspot(s:key("h"), bounds)).toBe(first)
	end)

	it("doesn't capture the wheel by default", function()
		const _, region = hotspot(scope.new(), bounds)
		expect(region.primitives[1].hotspot_wheel).toBe(false)
	end)

	it("captures the wheel when asked", function()
		const _, region = hotspot(scope.new(), bounds, { wheel = true })
		expect(region.primitives[1].hotspot_wheel).toBe(true)
	end)
end)

return nil
