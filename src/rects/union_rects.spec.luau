const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const compat = require("../compat")
const Rect = compat.Rect

const union_rects = require("./union_rects")

const function expect_rect(r: Rect, x0: number, y0: number, x1: number, y1: number)
	expect(r.Min.X).toBe(x0)
	expect(r.Min.Y).toBe(y0)
	expect(r.Max.X).toBe(x1)
	expect(r.Max.Y).toBe(y1)
end

describe("union_rects", function()
	it("returns the second rect when the first is nil", function()
		const b = Rect.new(1, 2, 3, 4)
		expect(union_rects(nil, b)).toBe(b)
	end)

	it("covers two separate rects", function()
		expect_rect(union_rects(Rect.new(0, 0, 10, 10), Rect.new(20, 5, 30, 15)), 0, 0, 30, 15)
	end)

	it("returns the outer rect when one contains the other", function()
		expect_rect(union_rects(Rect.new(0, 0, 100, 100), Rect.new(10, 10, 20, 20)), 0, 0, 100, 100)
	end)

	it("is the same regardless of argument order", function()
		const a, b = Rect.new(-5, 3, 8, 9), Rect.new(2, -4, 12, 6)
		const ab, ba = union_rects(a, b), union_rects(b, a)
		expect(ab.Min == ba.Min and ab.Max == ba.Max).toBe(true)
	end)

	it("includes zero-size rects", function()
		expect_rect(union_rects(Rect.new(0, 0, 10, 10), Rect.new(50, 50, 50, 50)), 0, 0, 50, 50)
	end)
end)

return nil
