const lest = require("@lest")
const spring_coefficients = require("./spring_coefficients")
const describe, it, expect = lest.describe, lest.it, lest.expect

const function near(a: number, b: number, epsilon: number?): boolean
	return math.abs(a - b) <= (epsilon or 1e-6)
end

const function displaced(t: number, damping: number, speed: number): number
	const pp, pv = spring_coefficients(t, damping, speed)
	return 1 * pp + 0 * pv
end

describe("spring_coefficients", function()
	it("doesn't move anything when no time passes", function()
		const pp, pv, vp, vv = spring_coefficients(0, 1, 10)
		expect(pp).toBe(1)
		expect(pv).toBe(0)
		expect(vp).toBe(0)
		expect(vv).toBe(1)
	end)

	it("doesn't move anything at zero speed", function()
		const pp, pv, vp, vv = spring_coefficients(1, 1, 0)
		expect(pp).toBe(1)
		expect(pv).toBe(0)
		expect(vp).toBe(0)
		expect(vv).toBe(1)
	end)

	it("matches the critically damped solution", function()
		-- x(t) = (1 + speed * t) * e^(-speed * t) for x(0) = 1, v(0) = 0
		const t, speed = 0.1, 10
		expect(near(displaced(t, 1, speed), (1 + speed * t) * math.exp(-speed * t))).toBe(true)
	end)

	it("settles towards the goal over time", function()
		for _, damping in { 0.5, 1, 2 } do
			expect(math.abs(displaced(10, damping, 10)) < 1e-3).toBe(true)
		end
	end)

	it("doesn't overshoot when critically damped or overdamped", function()
		for _, damping in { 1, 1.5, 3 } do
			for step = 1, 50 do
				expect(displaced(step / 50, damping, 10) >= -1e-9).toBe(true)
			end
		end
	end)

	it("overshoots when underdamped", function()
		local lowest = math.huge
		for step = 1, 100 do
			lowest = math.min(lowest, displaced(step / 100, 0.3, 10))
		end
		expect(lowest < 0).toBe(true)
	end)

	it("is continuous across damping = 1", function()
		const t, speed = 0.15, 10
		const critical = displaced(t, 1, speed)
		expect(near(displaced(t, 0.9999, speed), critical, 1e-3)).toBe(true)
		expect(near(displaced(t, 1.0001, speed), critical, 1e-3)).toBe(true)
	end)

	it("gives the same result in one step as in many smaller steps", function()
		const damping, speed = 0.6, 12
		const pp, _, _, _ = spring_coefficients(0.5, damping, speed)
		const one_x = pp

		local x, v = 1, 0
		const spp, spv, svp, svv = spring_coefficients(0.05, damping, speed)
		for _ = 1, 10 do
			x, v = x * spp + v * spv, x * svp + v * svv
		end

		expect(near(one_x, x, 1e-9)).toBe(true)
	end)
end)

return nil
