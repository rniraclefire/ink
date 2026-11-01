const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const compat = require("../compat")
const Rect = compat.Rect

const compose = require("../layout/compose")
const round = require("./round")
const solid = require("../composites/solid")
local types = require("../types")

describe("round", function()
	const c = compose({ solid(Rect.new(0, 0, 10, 10)), solid(Rect.new(10, 0, 20, 10)) })

	it("rounds every corner by a number", function()
		const r = round(c, 8).primitives[1].round :: any
		expect(r.tl).toBe(8)
		expect(r.tr).toBe(8)
		expect(r.bl).toBe(8)
		expect(r.br).toBe(8)
	end)

	it("applies to every primitive", function()
		const out = round(c, 8)
		expect(out.primitives[2].round ~= nil).toBe(true)
	end)

	it("uses a corner table as given", function()
		const style: types.RoundStyle = { tl = 8, tr = 8, bl = 0, br = 0 }
		expect(round(c, style).primitives[1].round).toBe(style)
	end)

	it("keeps the bounds", function()
		expect(round(c, 8).bounds).toBe(c.bounds)
	end)

	it("doesn't modify the original composite", function()
		round(c, 8)
		expect(c.primitives[1].round).toBe(nil)
	end)
end)

return nil
