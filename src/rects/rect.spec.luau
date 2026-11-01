const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const rect = require("./rect")

describe("rect", function()
	it("returns a Rect", function()
		expect(typeof(rect(0, 0, 10, 10))).toBe("Rect")
	end)

	it("constructs from the origin", function()
		const r = rect(0, 0, 100, 200)
		expect(r.Min.X).toBe(0)
		expect(r.Min.Y).toBe(0)
		expect(r.Max.X).toBe(100)
		expect(r.Max.Y).toBe(200)
	end)

	it("uses x and y as the top-left corner", function()
		const r = rect(30, 40, 100, 200)
		expect(r.Min.X).toBe(30)
		expect(r.Min.Y).toBe(40)
	end)

	it("places the bottom-right corner at position plus size", function()
		const r = rect(30, 40, 100, 200)
		expect(r.Max.X).toBe(130)
		expect(r.Max.Y).toBe(240)
	end)

	it("keeps width and height regardless of position", function()
		const r = rect(30, 40, 100, 200)
		expect(r.Width).toBe(100)
		expect(r.Height).toBe(200)
	end)

	it("supports negative positions", function()
		const r = rect(-50, -25, 100, 50)
		expect(r.Min.X).toBe(-50)
		expect(r.Min.Y).toBe(-25)
		expect(r.Max.X).toBe(50)
		expect(r.Max.Y).toBe(25)
	end)

	it("supports zero size", function()
		const r = rect(10, 20, 0, 0)
		expect(r.Width).toBe(0)
		expect(r.Height).toBe(0)
	end)

	it("supports fractional values", function()
		const r = rect(0.5, 1.25, 10.5, 20.75)
		expect(r.Max.X).toBe(11)
		expect(r.Max.Y).toBe(22)
	end)
end)

return nil
