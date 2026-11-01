const lest = require("@lest")
const compat = require("../compat")
const inset_rect_xy = require("./inset_rect_xy")
const describe, it, expect = lest.describe, lest.it, lest.expect

const Rect = compat.Rect

const function expect_rect(r: Rect, x0: number, y0: number, x1: number, y1: number)
	expect(r.Min.X).toBe(x0)
	expect(r.Min.Y).toBe(y0)
	expect(r.Max.X).toBe(x1)
	expect(r.Max.Y).toBe(y1)
end

describe("inset_rect_xy", function()
	it("applies x to the left and right sides", function()
		expect_rect(inset_rect_xy(Rect.new(0, 0, 100, 50), 10, 0), 10, 0, 90, 50)
	end)

	it("applies y to the top and bottom sides", function()
		expect_rect(inset_rect_xy(Rect.new(0, 0, 100, 50), 0, 5), 0, 5, 100, 45)
	end)

	it("grows with negative amounts", function()
		expect_rect(inset_rect_xy(Rect.new(0, 0, 100, 50), -10, -5), -10, -5, 110, 55)
	end)
end)

return nil
