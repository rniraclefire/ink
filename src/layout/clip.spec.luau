const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const compat = require("../compat")
const Rect = compat.Rect

const clip = require("./clip")
const compose = require("./compose")
const solid = require("../composites/solid")

describe("clip", function()
	const inside = solid(Rect.new(10, 10, 20, 20))
	const partial = solid(Rect.new(40, 40, 60, 60))
	const outside = solid(Rect.new(100, 100, 110, 110))
	const window = Rect.new(0, 0, 50, 50)

	it("keeps primitives inside the rect", function()
		const out = clip(inside, window)
		expect(#out.primitives).toBe(1)
	end)

	it("keeps primitives partly inside the rect", function()
		const out = clip(partial, window)
		expect(#out.primitives).toBe(1)
	end)

	it("drops primitives entirely outside the rect", function()
		const out = clip(compose({ inside, outside }), window)
		expect(#out.primitives).toBe(1)
		expect(out.primitives[1].bounds.Min.X).toBe(10)
	end)

	it("doesn't resize clipped primitives", function()
		const p = clip(partial, window).primitives[1]
		expect(p.bounds.Width).toBe(20)
	end)

	it("sets the clip on each kept primitive", function()
		const p = clip(inside, window).primitives[1]
		const c = p.clip :: Rect
		expect(c.Min.X).toBe(0)
		expect(c.Max.X).toBe(50)
	end)

	it("intersects with an existing clip", function()
		const once = clip(inside, Rect.new(0, 0, 15, 30))
		const twice = clip(once, Rect.new(5, 0, 50, 50))
		const c = twice.primitives[1].clip :: Rect
		expect(c.Min.X).toBe(5)
		expect(c.Max.X).toBe(15)
		expect(c.Max.Y).toBe(30)
	end)

	it("drops primitives outside an earlier clip", function()
		const once = clip(partial, Rect.new(0, 0, 45, 45))
		const twice = clip(once, Rect.new(46, 46, 100, 100))
		expect(#twice.primitives).toBe(0)
	end)

	it("bounds the result by the clip rect", function()
		const out = clip(compose({ inside, partial }), window)
		expect(out.bounds.Max.X <= 50).toBe(true)
		expect(out.bounds.Max.Y <= 50).toBe(true)
	end)

	it("doesn't modify the original composite", function()
		clip(inside, window)
		expect(inside.primitives[1].clip).toBe(nil)
	end)
end)

return nil
