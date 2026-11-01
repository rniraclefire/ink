const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const compat = require("../compat")
const Rect = compat.Rect

const solid = require("../composites/solid")
const v_stack = require("./v_stack")

describe("v_stack", function()
	const small = solid(Rect.new(0, 0, 10, 10))
	const wide = solid(Rect.new(0, 0, 30, 20))

	it("places items top to bottom", function()
		const out = v_stack({ small, wide })
		expect(out.primitives[1].bounds.Min.Y).toBe(0)
		expect(out.primitives[2].bounds.Min.Y).toBe(10)
	end)

	it("adds the gap between items", function()
		const out = v_stack({ small, wide, small }, 5)
		expect(out.primitives[2].bounds.Min.Y).toBe(15)
		expect(out.primitives[3].bounds.Min.Y).toBe(40)
	end)

	it("doesn't add a gap after the last item", function()
		const out = v_stack({ small, wide }, 5)
		expect(out.bounds.Max.Y).toBe(35)
	end)

	it("starts at the first item's top edge", function()
		const out = v_stack({ solid(Rect.new(0, 50, 10, 60)), small })
		expect(out.bounds.Min.Y).toBe(50)
		expect(out.primitives[2].bounds.Min.Y).toBe(60)
	end)

	it("leaves horizontal positions alone without an alignment", function()
		const out = v_stack({ small, solid(Rect.new(40, 0, 50, 10)) })
		expect(out.primitives[2].bounds.Min.X).toBe(40)
	end)

	it("aligns left edges with 0", function()
		const out = v_stack({ small, wide }, 0, 0)
		expect(out.primitives[1].bounds.Min.X).toBe(0)
	end)

	it("centres within the widest item with 0.5", function()
		const out = v_stack({ small, wide }, 0, 0.5)
		expect(out.primitives[1].bounds.Min.X).toBe(10)
	end)

	it("aligns right edges with 1", function()
		const out = v_stack({ small, wide }, 0, 1)
		expect(out.primitives[1].bounds.Max.X).toBe(30)
	end)

	it("bounds every item", function()
		const out = v_stack({ small, wide }, 5, 0)
		expect(out.bounds.Max.X).toBe(30)
		expect(out.bounds.Max.Y).toBe(35)
	end)

	it("returns an empty composite for no items", function()
		const out = v_stack({})
		expect(#out.primitives).toBe(0)
		expect(out.bounds.Height).toBe(0)
	end)
end)

return nil
