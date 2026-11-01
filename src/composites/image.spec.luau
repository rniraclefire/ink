const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const compat = require("../compat")
const Rect = compat.Rect

const image = require("./image")
local types = require("../types")

describe("image", function()
	const bounds = Rect.new(0, 0, 24, 24)

	it("contains one primitive with the image", function()
		const c = image(bounds, "rbxassetid://1")
		expect(#c.primitives).toBe(1)
		expect(c.primitives[1].image).toBe("rbxassetid://1")
	end)

	it("uses the rect as its bounds", function()
		const c = image(bounds, "rbxassetid://1")
		expect(c.bounds).toBe(bounds)
		expect(c.primitives[1].bounds).toBe(bounds)
	end)

	it("stores the style as given", function()
		const style: types.ImageStyle = { slice_scale = 2 }
		expect(image(bounds, "rbxassetid://1", style).primitives[1].image_style).toBe(style)
	end)
end)

return nil
