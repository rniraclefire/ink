const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const compat = require("../compat")
const Rect, Color3 = compat.Rect, compat.Color3

const compose = require("../layout/compose")
const solid = require("../composites/solid")
const tint = require("./tint")

const RED = Color3.new(1, 0, 0)
const BLUE = Color3.new(0, 0, 1)

describe("tint", function()
	const c = compose({ solid(Rect.new(0, 0, 10, 10), RED), solid(Rect.new(10, 0, 20, 10), RED) })

	it("recolours every primitive", function()
		const out = tint(c, BLUE)
		expect(out.primitives[1].color).toBe(BLUE)
		expect(out.primitives[2].color).toBe(BLUE)
	end)

	it("keeps the existing colour when none is given", function()
		const out = tint(c, nil, 0.5)
		expect(out.primitives[1].color).toBe(RED)
	end)

	it("sets transparency on primitives without one", function()
		const out = tint(c, nil, 0.5)
		expect(out.primitives[1].transparency).toBe(0.5)
	end)

	it("keeps the existing transparency when none is given", function()
		const faded = solid(Rect.new(0, 0, 10, 10), RED, 0.3)
		expect(tint(faded, BLUE).primitives[1].transparency).toBe(0.3)
	end)

	it("keeps the bounds", function()
		expect(tint(c, BLUE).bounds).toBe(c.bounds)
	end)

	it("doesn't modify the original composite", function()
		tint(c, BLUE, 0.5)
		expect(c.primitives[1].color).toBe(RED)
		expect(c.primitives[1].transparency).toBe(nil)
	end)
end)

return nil
