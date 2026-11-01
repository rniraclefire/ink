const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const compat = require("../compat")
const Rect = compat.Rect

const compose = require("./compose")
const solid = require("../composites/solid")
const translate = require("./translate")
local types = require("../types")

describe("translate", function()
	const c = compose({ solid(Rect.new(0, 0, 10, 10)), solid(Rect.new(20, 0, 30, 10)) })

	it("moves the composite's bounds", function()
		const moved = translate(c, 5, 7)
		expect(moved.bounds.Min.X).toBe(5)
		expect(moved.bounds.Min.Y).toBe(7)
		expect(moved.bounds.Max.X).toBe(35)
		expect(moved.bounds.Max.Y).toBe(17)
	end)

	it("moves every primitive by the same offset", function()
		const moved = translate(c, 5, 7)
		expect(moved.primitives[1].bounds.Min.X).toBe(5)
		expect(moved.primitives[2].bounds.Min.X).toBe(25)
		expect(moved.primitives[2].bounds.Min.Y).toBe(7)
	end)

	it("keeps sizes unchanged", function()
		const moved = translate(c, 5, 7)
		expect(moved.primitives[1].bounds.Width).toBe(10)
		expect(moved.bounds.Width).toBe(30)
	end)

	it("moves clips along with their primitives", function()
		const clipped: types.Composite = {
			primitives = { { bounds = Rect.new(0, 0, 10, 10), clip = Rect.new(0, 0, 5, 5) } },
			bounds = Rect.new(0, 0, 10, 10),
		}
		const moved = translate(clipped, 3, 4)
		const clip = moved.primitives[1].clip :: Rect
		expect(clip.Min.X).toBe(3)
		expect(clip.Min.Y).toBe(4)
		expect(clip.Max.X).toBe(8)
		expect(clip.Max.Y).toBe(9)
	end)

	it("treats a missing y offset as zero", function()
		const moved = translate(c, 5)
		expect(moved.bounds.Min.X).toBe(5)
		expect(moved.bounds.Min.Y).toBe(0)
	end)

	it("doesn't modify the original composite", function()
		translate(c, 5, 7)
		expect(c.bounds.Min.X).toBe(0)
		expect(c.primitives[1].bounds.Min.X).toBe(0)
	end)

	it("keeps paint order", function()
		const moved = translate(c, 1, 1)
		expect(moved.primitives[1].bounds.Min.X < moved.primitives[2].bounds.Min.X).toBe(true)
	end)
end)

return nil
