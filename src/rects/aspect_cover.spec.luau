const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const compat = require("../compat")
const Rect = compat.Rect

const aspect_cover = require("./aspect_cover")

const function expect_rect(r: Rect, x0: number, y0: number, x1: number, y1: number)
	expect(r.Min.X).toBe(x0)
	expect(r.Min.Y).toBe(y0)
	expect(r.Max.X).toBe(x1)
	expect(r.Max.Y).toBe(y1)
end

describe("aspect_cover", function()
	it("covers a wide container with a square, centred", function()
		expect_rect(aspect_cover(Rect.new(0, 0, 200, 100), 1), 0, -50, 200, 150)
	end)

	it("covers a tall container with a square, centred", function()
		expect_rect(aspect_cover(Rect.new(0, 0, 100, 200), 1), -50, 0, 150, 200)
	end)

	it("matches a container with the same aspect ratio", function()
		expect_rect(aspect_cover(Rect.new(0, 0, 160, 90), 16 / 9), 0, 0, 160, 90)
	end)

	it("always covers the whole container", function()
		const container = Rect.new(0, 0, 300, 120)
		const r = aspect_cover(container, 0.75)
		expect(r.Min.X <= 0 and r.Min.Y <= 0).toBe(true)
		expect(r.Max.X >= 300 and r.Max.Y >= 120).toBe(true)
	end)

	it("keeps the requested aspect ratio", function()
		const r = aspect_cover(Rect.new(0, 0, 333, 777), 16 / 9)
		const ratio = r.Width / r.Height
		expect(math.abs(ratio - 16 / 9) / (16 / 9) < 1e-5).toBe(true)
	end)

	it("keeps the top visible with a 0 vertical anchor", function()
		expect_rect(aspect_cover(Rect.new(0, 0, 200, 100), 1, 0.5, 0), 0, 0, 200, 200)
	end)
end)

return nil
