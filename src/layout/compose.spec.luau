const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const compat = require("../compat")
const Rect = compat.Rect

const compose = require("./compose")
const solid = require("../composites/solid")

describe("compose", function()
	const a = solid(Rect.new(0, 0, 10, 10))
	const b = solid(Rect.new(20, 5, 30, 15))

	it("keeps every primitive in paint order", function()
		const c = compose({ a, b })
		expect(#c.primitives).toBe(2)
		expect(c.primitives[1]).toBe(a.primitives[1])
		expect(c.primitives[2]).toBe(b.primitives[1])
	end)

	it("bounds the union of every composite", function()
		const c = compose({ a, b })
		expect(c.bounds.Min.X).toBe(0)
		expect(c.bounds.Min.Y).toBe(0)
		expect(c.bounds.Max.X).toBe(30)
		expect(c.bounds.Max.Y).toBe(15)
	end)

	it("uses the given bounds when provided", function()
		const override = Rect.new(-5, -5, 5, 5)
		expect(compose({ a, b }, override).bounds).toBe(override)
	end)

	it("returns an empty composite for an empty list", function()
		const c = compose({})
		expect(#c.primitives).toBe(0)
		expect(c.bounds.Width).toBe(0)
		expect(c.bounds.Height).toBe(0)
	end)

	it("doesn't modify the composites passed in", function()
		compose({ a, b })
		expect(#a.primitives).toBe(1)
		expect(#b.primitives).toBe(1)
	end)
end)

return nil
