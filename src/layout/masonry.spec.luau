const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const compat = require("../compat")
const Rect = compat.Rect

const masonry = require("./masonry")
const solid = require("../composites/solid")

const function item(height: number)
	return solid(Rect.new(0, 0, 50, height))
end

describe("masonry", function()
	it("fills the first row left to right", function()
		const out = masonry({ item(10), item(20) }, 2, 50, 4)
		expect(out.primitives[1].bounds.Min.X).toBe(0)
		expect(out.primitives[2].bounds.Min.X).toBe(54)
		expect(out.primitives[2].bounds.Min.Y).toBe(0)
	end)

	it("places each next item in the shortest column", function()
		const out = masonry({ item(10), item(20), item(5) }, 2, 50, 4)
		-- column 1 ends at 10 + gap, column 2 at 20 + gap, so item 3 goes in column 1
		expect(out.primitives[3].bounds.Min.X).toBe(0)
		expect(out.primitives[3].bounds.Min.Y).toBe(14)
	end)

	it("prefers the leftmost column when heights are equal", function()
		const out = masonry({ item(10), item(10), item(10) }, 2, 50, 0)
		expect(out.primitives[3].bounds.Min.X).toBe(0)
	end)

	it("bounds the placed items without a trailing gap", function()
		const out = masonry({ item(10), item(20), item(5) }, 2, 50, 4)
		expect(out.bounds.Max.X).toBe(104)
		expect(out.bounds.Max.Y).toBe(20)
	end)

	it("returns an empty composite for no items", function()
		const out = masonry({}, 3, 50, 4)
		expect(#out.primitives).toBe(0)
	end)
end)

return nil
