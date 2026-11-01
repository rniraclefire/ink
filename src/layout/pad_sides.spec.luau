const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const compat = require("../compat")
const Rect = compat.Rect

const pad_sides = require("./pad_sides")
const solid = require("../composites/solid")

describe("pad_sides", function()
	const c = solid(Rect.new(0, 0, 100, 100))

	it("pads the top", function()
		expect(pad_sides(c, 10, 0, 0, 0).bounds.Min.Y).toBe(-10)
	end)

	it("pads the left", function()
		expect(pad_sides(c, 0, 10, 0, 0).bounds.Min.X).toBe(-10)
	end)

	it("pads the bottom", function()
		expect(pad_sides(c, 0, 0, 10, 0).bounds.Max.Y).toBe(110)
	end)

	it("pads the right", function()
		expect(pad_sides(c, 0, 0, 0, 10).bounds.Max.X).toBe(110)
	end)

	it("treats missing sides as zero", function()
		const out = pad_sides(c, 5)
		expect(out.bounds.Min.Y).toBe(-5)
		expect(out.bounds.Min.X).toBe(0)
		expect(out.bounds.Max.X).toBe(100)
		expect(out.bounds.Max.Y).toBe(100)
	end)

	it("doesn't move the contents", function()
		expect(pad_sides(c, 1, 2, 3, 4).primitives[1].bounds.Min.X).toBe(0)
	end)
end)

return nil
