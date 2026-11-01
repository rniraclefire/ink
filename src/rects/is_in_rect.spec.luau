const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const compat = require("../compat")
const Rect, Vector2 = compat.Rect, compat.Vector2

const is_in_rect = require("./is_in_rect")

describe("is_in_rect", function()
	const r = Rect.new(10, 10, 20, 20)

	it("contains points inside", function()
		expect(is_in_rect(r, Vector2.new(15, 15))).toBe(true)
	end)

	it("includes the top and left edges", function()
		expect(is_in_rect(r, Vector2.new(10, 10))).toBe(true)
	end)

	it("excludes the bottom and right edges", function()
		expect(is_in_rect(r, Vector2.new(20, 15))).toBe(false)
		expect(is_in_rect(r, Vector2.new(15, 20))).toBe(false)
	end)

	it("excludes points outside", function()
		expect(is_in_rect(r, Vector2.new(5, 15))).toBe(false)
		expect(is_in_rect(r, Vector2.new(15, 25))).toBe(false)
	end)

	it("never contains anything when zero-sized", function()
		expect(is_in_rect(Rect.new(10, 10, 10, 10), Vector2.new(10, 10))).toBe(false)
	end)
end)

return nil
