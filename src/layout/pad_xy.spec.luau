const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const compat = require("../compat")
const Rect = compat.Rect

const pad_xy = require("./pad_xy")
const solid = require("../composites/solid")

describe("pad_xy", function()
	const c = solid(Rect.new(0, 0, 100, 50))

	it("applies x to the left and right", function()
		const out = pad_xy(c, 16, 0)
		expect(out.bounds.Min.X).toBe(-16)
		expect(out.bounds.Max.X).toBe(116)
		expect(out.bounds.Height).toBe(50)
	end)

	it("applies y to the top and bottom", function()
		const out = pad_xy(c, 0, 12)
		expect(out.bounds.Min.Y).toBe(-12)
		expect(out.bounds.Max.Y).toBe(62)
		expect(out.bounds.Width).toBe(100)
	end)

	it("treats missing amounts as zero", function()
		const out = pad_xy(c, 4)
		expect(out.bounds.Width).toBe(108)
		expect(out.bounds.Height).toBe(50)
	end)

	it("doesn't move the contents", function()
		const out = pad_xy(c, 16, 12)
		expect(out.primitives[1].bounds.Min.X).toBe(0)
	end)
end)

return nil
