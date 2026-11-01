const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const compat = require("../compat")
const Rect = compat.Rect

const inset_rect_sides = require("./inset_rect_sides")

describe("inset_rect_sides", function()
	const r = Rect.new(0, 0, 100, 100)

	it("insets the top", function()
		const out = inset_rect_sides(r, 10, 0, 0, 0)
		expect(out.Min.Y).toBe(10)
		expect(out.Min.X).toBe(0)
		expect(out.Max.X).toBe(100)
		expect(out.Max.Y).toBe(100)
	end)

	it("insets the left", function()
		const out = inset_rect_sides(r, 0, 10, 0, 0)
		expect(out.Min.X).toBe(10)
		expect(out.Min.Y).toBe(0)
	end)

	it("insets the bottom", function()
		const out = inset_rect_sides(r, 0, 0, 10, 0)
		expect(out.Max.Y).toBe(90)
		expect(out.Max.X).toBe(100)
	end)

	it("insets the right", function()
		const out = inset_rect_sides(r, 0, 0, 0, 10)
		expect(out.Max.X).toBe(90)
		expect(out.Max.Y).toBe(100)
	end)

	it("collapses to zero size instead of inverting", function()
		const out = inset_rect_sides(r, 80, 80, 80, 80)
		expect(out.Width).toBe(0)
		expect(out.Height).toBe(0)
	end)
end)

return nil
