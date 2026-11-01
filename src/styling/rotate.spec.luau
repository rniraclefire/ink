const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const compat = require("../compat")
const Rect = compat.Rect

const compose = require("../layout/compose")
const rotate = require("./rotate")
const solid = require("../composites/solid")

const function near(a: number, b: number): boolean
	return math.abs(a - b) < 1e-6
end

describe("rotate", function()
	it("sets the rotation of a single primitive", function()
		const out = rotate(solid(Rect.new(0, 0, 10, 10)), 45)
		expect(out.primitives[1].rotation).toBe(45)
	end)

	it("keeps a single primitive in place, since it spins around its own centre", function()
		const out = rotate(solid(Rect.new(0, 0, 10, 10)), 45)
		expect(out.primitives[1].bounds.Min.X).toBe(0)
		expect(out.primitives[1].bounds.Min.Y).toBe(0)
	end)

	it("adds to an existing rotation", function()
		const once = rotate(solid(Rect.new(0, 0, 10, 10)), 30)
		expect(rotate(once, 15).primitives[1].rotation).toBe(45)
	end)

	it("moves primitives around the composite's centre", function()
		-- two 10x10 squares side by side; the composite's centre is (20, 5)
		const c = compose({ solid(Rect.new(0, 0, 10, 10)), solid(Rect.new(30, 0, 40, 10)) })
		const out = rotate(c, 180)
		-- after a half turn, the left square's centre (5, 5) ends up at (35, 5)
		const b = out.primitives[1].bounds
		expect(near(b.Min.X + b.Width / 2, 35)).toBe(true)
		expect(near(b.Min.Y + b.Height / 2, 5)).toBe(true)
	end)

	it("doesn't modify the original composite", function()
		const c = solid(Rect.new(0, 0, 10, 10))
		rotate(c, 45)
		expect(c.primitives[1].rotation).toBe(nil)
	end)
end)

return nil
