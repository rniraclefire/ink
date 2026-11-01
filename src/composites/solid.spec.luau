const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const compat = require("../compat")
const Rect, Color3 = compat.Rect, compat.Color3

const solid = require("./solid")

describe("solid", function()
	const bounds = Rect.new(0, 0, 10, 20)

	it("contains one primitive", function()
		expect(#solid(bounds).primitives).toBe(1)
	end)

	it("uses the rect as both the primitive's and the composite's bounds", function()
		const c = solid(bounds)
		expect(c.bounds).toBe(bounds)
		expect(c.primitives[1].bounds).toBe(bounds)
	end)

	it("stores the colour and transparency", function()
		const red = Color3.new(1, 0, 0)
		const p = solid(bounds, red, 0.5).primitives[1]
		expect(p.color).toBe(red)
		expect(p.transparency).toBe(0.5)
	end)

	it("has no text, image or hotspot", function()
		const p = solid(bounds).primitives[1]
		expect(p.text).toBe(nil)
		expect(p.image).toBe(nil)
		expect(p.hit_region).toBe(nil)
	end)
end)

return nil
