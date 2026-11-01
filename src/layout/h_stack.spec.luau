const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const compat = require("../compat")
const Rect = compat.Rect

const h_stack = require("./h_stack")
const solid = require("../composites/solid")

describe("h_stack", function()
	const small = solid(Rect.new(0, 0, 10, 10))
	const tall = solid(Rect.new(0, 0, 20, 30))

	it("places items left to right", function()
		const out = h_stack({ small, tall })
		expect(out.primitives[1].bounds.Min.X).toBe(0)
		expect(out.primitives[2].bounds.Min.X).toBe(10)
	end)

	it("adds the gap between items", function()
		const out = h_stack({ small, tall, small }, 5)
		expect(out.primitives[2].bounds.Min.X).toBe(15)
		expect(out.primitives[3].bounds.Min.X).toBe(40)
	end)

	it("doesn't add a gap after the last item", function()
		const out = h_stack({ small, tall }, 5)
		expect(out.bounds.Max.X).toBe(35)
	end)

	it("starts at the first item's left edge", function()
		const out = h_stack({ solid(Rect.new(50, 0, 60, 10)), small })
		expect(out.bounds.Min.X).toBe(50)
		expect(out.primitives[2].bounds.Min.X).toBe(60)
	end)

	it("leaves vertical positions alone without an alignment", function()
		const out = h_stack({ small, solid(Rect.new(0, 40, 10, 50)) })
		expect(out.primitives[2].bounds.Min.Y).toBe(40)
	end)

	it("aligns tops with 0", function()
		const out = h_stack({ small, tall }, 0, 0)
		expect(out.primitives[1].bounds.Min.Y).toBe(0)
	end)

	it("centres within the tallest item with 0.5", function()
		const out = h_stack({ small, tall }, 0, 0.5)
		expect(out.primitives[1].bounds.Min.Y).toBe(10)
	end)

	it("aligns bottoms with 1", function()
		const out = h_stack({ small, tall }, 0, 1)
		expect(out.primitives[1].bounds.Max.Y).toBe(30)
	end)

	it("bounds every item", function()
		const out = h_stack({ small, tall }, 5, 0)
		expect(out.bounds.Min.X).toBe(0)
		expect(out.bounds.Min.Y).toBe(0)
		expect(out.bounds.Max.X).toBe(35)
		expect(out.bounds.Max.Y).toBe(30)
	end)

	it("returns an empty composite for no items", function()
		const out = h_stack({})
		expect(#out.primitives).toBe(0)
		expect(out.bounds.Width).toBe(0)
	end)

	it("doesn't modify the items passed in", function()
		h_stack({ small, tall }, 5)
		expect(tall.primitives[1].bounds.Min.X).toBe(0)
	end)
end)

return nil
