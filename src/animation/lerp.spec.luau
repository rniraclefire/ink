const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const compat = require("../compat")
const Vector2, Color3 = compat.Vector2, compat.Color3

const lerp = require("./lerp")

const function near(a: number, b: number, epsilon: number?): boolean
	return math.abs(a - b) <= (epsilon or 1e-6)
end

describe("lerp", function()
	it("returns the initial value at 0", function()
		expect(lerp(10, 20, 0)).toBe(10)
	end)

	it("returns the goal value at 1", function()
		expect(lerp(10, 20, 1)).toBe(20)
	end)

	it("interpolates numbers", function()
		expect(lerp(10, 20, 0.5)).toBe(15)
	end)

	it("interpolates Vector2s per component", function()
		const v = lerp(Vector2.new(0, 10), Vector2.new(10, 30), 0.5)
		expect(v.X).toBe(5)
		expect(v.Y).toBe(20)
	end)

	it("returns the exact colours at the ends", function()
		const a, b = Color3.new(1, 0, 0), Color3.new(0, 0, 1)
		const start, finish = lerp(a, b, 0), lerp(a, b, 1)
		expect(near(start.R, 1, 1e-3) and near(start.B, 0, 1e-3)).toBe(true)
		expect(near(finish.R, 0, 1e-3) and near(finish.B, 1, 1e-3)).toBe(true)
	end)

	it("blends colours somewhere between the two", function()
		const mid = lerp(Color3.new(0, 0, 0), Color3.new(1, 1, 1), 0.5)
		expect(mid.R > 0.1 and mid.R < 0.9).toBe(true)
	end)

	it("keeps colours inside the displayable range", function()
		const mid = lerp(Color3.new(1, 0, 0), Color3.new(0, 1, 1), 0.5)
		for _, c in { mid.R, mid.G, mid.B } do
			expect(c >= 0 and c <= 1).toBe(true)
		end
	end)

	it("errors when the two values are different types", function()
		expect((pcall(lerp, 1 :: any, Vector2.zero :: any, 0.5))).toBe(false)
	end)

	it("errors for a type it can't interpolate", function()
		expect((pcall(lerp, "a" :: any, "b" :: any, 0.5))).toBe(false)
	end)
end)

return nil
