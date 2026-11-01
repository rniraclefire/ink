const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const compat = require("../compat")
const Rect = compat.Rect

const aspect_fit = require("./aspect_fit")

const function expect_rect(r: Rect, x0: number, y0: number, x1: number, y1: number)
	expect(r.Min.X).toBe(x0)
	expect(r.Min.Y).toBe(y0)
	expect(r.Max.X).toBe(x1)
	expect(r.Max.Y).toBe(y1)
end

describe("aspect_fit", function()
	it("fits a square inside a wide container, centred", function()
		expect_rect(aspect_fit(Rect.new(0, 0, 200, 100), 1), 50, 0, 150, 100)
	end)

	it("fits a square inside a tall container, centred", function()
		expect_rect(aspect_fit(Rect.new(0, 0, 100, 200), 1), 0, 50, 100, 150)
	end)

	it("fills a container with the same aspect ratio", function()
		expect_rect(aspect_fit(Rect.new(0, 0, 160, 90), 16 / 9), 0, 0, 160, 90)
	end)

	it("never exceeds the container", function()
		const r = aspect_fit(Rect.new(0, 0, 300, 120), 2.5)
		expect(r.Width <= 300).toBe(true)
		expect(r.Height <= 120).toBe(true)
	end)

	it("keeps the requested aspect ratio", function()
		const r = aspect_fit(Rect.new(0, 0, 333, 777), 16 / 9)
		expect(math.abs(r.Width / r.Height - 16 / 9) < 1e-9).toBe(true)
	end)

	it("aligns to the start with 0 anchors", function()
		expect_rect(aspect_fit(Rect.new(0, 0, 200, 100), 1, 0, 0), 0, 0, 100, 100)
	end)

	it("aligns to the end with 1 anchors", function()
		expect_rect(aspect_fit(Rect.new(0, 0, 200, 100), 1, 1, 1), 100, 0, 200, 100)
	end)

	it("respects the container's position", function()
		expect_rect(aspect_fit(Rect.new(10, 20, 210, 120), 1), 60, 20, 160, 120)
	end)
end)

return nil
