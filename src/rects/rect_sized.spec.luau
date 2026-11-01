const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const rect_sized = require("./rect_sized")

describe("rect_sized", function()
	it("places the rect at the origin", function()
		const r = rect_sized(100, 50)
		expect(r.Min.X).toBe(0)
		expect(r.Min.Y).toBe(0)
	end)

	it("uses the given width and height", function()
		const r = rect_sized(100, 50)
		expect(r.Width).toBe(100)
		expect(r.Height).toBe(50)
		expect(r.Max.X).toBe(100)
		expect(r.Max.Y).toBe(50)
	end)

	it("supports zero size", function()
		const r = rect_sized(0, 0)
		expect(r.Width).toBe(0)
		expect(r.Height).toBe(0)
	end)
end)

return nil
