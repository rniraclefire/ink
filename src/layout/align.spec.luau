const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const compat = require("../compat")
const Rect = compat.Rect

const align = require("./align")
const solid = require("../composites/solid")

describe("align", function()
	const box = solid(Rect.new(0, 0, 20, 10))
	const container = Rect.new(0, 0, 100, 50)

	it("centres with 0.5 anchors", function()
		const out = align(box, container, 0.5, 0.5)
		expect(out.bounds.Min.X).toBe(40)
		expect(out.bounds.Min.Y).toBe(20)
	end)

	it("aligns to the top-left with 0 anchors", function()
		const out = align(solid(Rect.new(30, 30, 50, 40)), container, 0, 0)
		expect(out.bounds.Min.X).toBe(0)
		expect(out.bounds.Min.Y).toBe(0)
	end)

	it("aligns to the bottom-right with 1 anchors", function()
		const out = align(box, container, 1, 1)
		expect(out.bounds.Max.X).toBe(100)
		expect(out.bounds.Max.Y).toBe(50)
	end)

	it("leaves an axis alone when its anchor is nil", function()
		const out = align(solid(Rect.new(0, 7, 20, 17)), container, 0.5, nil)
		expect(out.bounds.Min.X).toBe(40)
		expect(out.bounds.Min.Y).toBe(7)
	end)

	it("respects the container's position", function()
		const out = align(box, Rect.new(100, 200, 200, 250), 0, 0)
		expect(out.bounds.Min.X).toBe(100)
		expect(out.bounds.Min.Y).toBe(200)
	end)

	it("moves the primitives too, not just the bounds", function()
		const out = align(box, container, 0.5, 0.5)
		expect(out.primitives[1].bounds.Min.X).toBe(40)
	end)

	it("returns the same composite when nothing moves", function()
		expect(align(box, container, 0, 0)).toBe(box)
	end)
end)

return nil
