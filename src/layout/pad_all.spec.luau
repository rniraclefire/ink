const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const compat = require("../compat")
const Rect = compat.Rect

const pad_all = require("./pad_all")
const solid = require("../composites/solid")

describe("pad_all", function()
	const c = solid(Rect.new(0, 0, 100, 50))

	it("grows the bounds on every side", function()
		const out = pad_all(c, 8)
		expect(out.bounds.Min.X).toBe(-8)
		expect(out.bounds.Min.Y).toBe(-8)
		expect(out.bounds.Max.X).toBe(108)
		expect(out.bounds.Max.Y).toBe(58)
	end)

	it("doesn't move the contents", function()
		const out = pad_all(c, 8)
		expect(out.primitives[1].bounds.Min.X).toBe(0)
		expect(out.primitives[1].bounds.Max.X).toBe(100)
	end)

	it("shrinks the bounds with a negative amount", function()
		const out = pad_all(c, -10)
		expect(out.bounds.Width).toBe(80)
		expect(out.bounds.Height).toBe(30)
	end)

	it("doesn't modify the original composite", function()
		pad_all(c, 8)
		expect(c.bounds.Min.X).toBe(0)
	end)
end)

return nil
