const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const compat = require("../compat")
const Rect = compat.Rect

const is_equal_rects = require("./is_equal_rects")

describe("is_equal_rects", function()
	it("treats two nils as equal", function()
		expect(is_equal_rects(nil, nil)).toBe(true)
	end)

	it("treats nil and a rect as different", function()
		expect(is_equal_rects(nil, Rect.new(0, 0, 1, 1))).toBe(false)
		expect(is_equal_rects(Rect.new(0, 0, 1, 1), nil)).toBe(false)
	end)

	it("compares by value, not by reference", function()
		expect(is_equal_rects(Rect.new(1, 2, 3, 4), Rect.new(1, 2, 3, 4))).toBe(true)
	end)

	it("detects a different position", function()
		expect(is_equal_rects(Rect.new(0, 0, 10, 10), Rect.new(1, 0, 11, 10))).toBe(false)
	end)

	it("detects a different size", function()
		expect(is_equal_rects(Rect.new(0, 0, 10, 10), Rect.new(0, 0, 10, 11))).toBe(false)
	end)
end)

return nil
