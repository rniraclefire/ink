const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const compat = require("../compat")
const Rect, Enum = compat.Rect, compat.Enum

const hit_region = require("./hit_region")
const scope = require("../state/scope")

describe("hotspot", function()
	const bounds = Rect.new(0, 0, 50, 20)

	it("starts idle and unclicked", function()
		const hit = hit_region(scope.new(), bounds)
		expect(hit.state).toBe(Enum.GuiState.Idle)
		expect(hit.clicked).toBe(false)
		expect(hit.wheel).toBe(0)
	end)

	it("returns a composite with one hotspot primitive", function()
		const hit, region = hit_region(scope.new(), bounds)
		expect(#region.primitives).toBe(1)
		expect(region.primitives[1].hit_region).toBe(hit)
		expect(region.bounds).toBe(bounds)
	end)

	it("keeps the same state while its key is requested", function()
		const s = scope.new()
		const first = hit_region(s:key("h"), bounds)
		s:next(1 / 60)
		expect(hit_region(s:key("h"), bounds)).toBe(first)
	end)

	it("doesn't capture the wheel by default", function()
		const _, region = hit_region(scope.new(), bounds)
		expect(region.primitives[1].hit_region_wheel).toBe(false)
	end)

	it("captures the wheel when asked", function()
		const _, region = hit_region(scope.new(), bounds, { wheel = true })
		expect(region.primitives[1].hit_region_wheel).toBe(true)
	end)
end)

return nil
