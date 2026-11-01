const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const compat = require("../compat")
const Rect = compat.Rect

const inset_rect = require("./inset_rect")

const function expect_rect(r: Rect, x0: number, y0: number, x1: number, y1: number)
	expect(r.Min.X).toBe(x0)
	expect(r.Min.Y).toBe(y0)
	expect(r.Max.X).toBe(x1)
	expect(r.Max.Y).toBe(y1)
end

describe("inset_rect", function()
	it("shrinks every side by the same amount", function()
		expect_rect(inset_rect(Rect.new(0, 0, 100, 50), 10), 10, 10, 90, 40)
	end)

	it("grows every side with a negative amount", function()
		expect_rect(inset_rect(Rect.new(0, 0, 100, 50), -10), -10, -10, 110, 60)
	end)

	it("leaves the rect unchanged with zero", function()
		expect_rect(inset_rect(Rect.new(5, 6, 7, 8), 0), 5, 6, 7, 8)
	end)

	it("collapses to zero size instead of inverting", function()
		const r = inset_rect(Rect.new(0, 0, 10, 10), 20)
		expect(r.Width).toBe(0)
		expect(r.Height).toBe(0)
	end)
end)

return nil
