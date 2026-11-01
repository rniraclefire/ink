const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const visible_range = require("./visible_range")

describe("visible_range", function()
	it("returns the rows visible at the top", function()
		const first, last = visible_range(0, 100, 20, 50)
		expect(first).toBe(1)
		expect(last).toBe(5)
	end)

	it("includes partially visible rows at both ends", function()
		const first, last = visible_range(30, 100, 20, 50)
		expect(first).toBe(2)
		expect(last).toBe(7)
	end)

	it("doesn't go past the last item", function()
		const first, last = visible_range(950, 100, 20, 50)
		expect(first).toBe(48)
		expect(last).toBe(50)
	end)

	it("doesn't start before the first item", function()
		const first = visible_range(-40, 100, 20, 50)
		expect(first).toBe(1)
	end)

	it("returns an empty range for no items", function()
		const first, last = visible_range(0, 100, 20, 0)
		expect(first > last).toBe(true)
	end)
end)

return nil
