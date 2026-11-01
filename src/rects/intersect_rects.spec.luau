const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const compat = require("../compat")
const Rect = compat.Rect

const intersect_rects = require("./intersect_rects")

const function expect_rect(r: Rect, x0: number, y0: number, x1: number, y1: number)
	expect(r.Min.X).toBe(x0)
	expect(r.Min.Y).toBe(y0)
	expect(r.Max.X).toBe(x1)
	expect(r.Max.Y).toBe(y1)
end

describe("intersect_rects", function()
	it("returns the overlapping area", function()
		expect_rect(intersect_rects(Rect.new(0, 0, 10, 10), Rect.new(5, 5, 15, 15)), 5, 5, 10, 10)
	end)

	it("returns the inner rect when one contains the other", function()
		expect_rect(intersect_rects(Rect.new(0, 0, 100, 100), Rect.new(10, 20, 30, 40)), 10, 20, 30, 40)
	end)

	it("collapses to zero size when the rects don't overlap", function()
		const r = intersect_rects(Rect.new(0, 0, 10, 10), Rect.new(20, 20, 30, 30))
		expect(r.Width).toBe(0)
		expect(r.Height).toBe(0)
	end)

	it("collapses to zero width when the rects only touch", function()
		const r = intersect_rects(Rect.new(0, 0, 10, 10), Rect.new(10, 0, 20, 10))
		expect(r.Width).toBe(0)
	end)

	it("is the same regardless of argument order", function()
		const a, b = Rect.new(-5, 3, 8, 9), Rect.new(2, -4, 12, 6)
		const ab, ba = intersect_rects(a, b), intersect_rects(b, a)
		expect(ab.Min == ba.Min and ab.Max == ba.Max).toBe(true)
	end)
end)

return nil
