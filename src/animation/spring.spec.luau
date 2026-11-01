const compat = require("../compat")
const lest = require("@lest")
const scope = require("../state/scope")
const spring = require("./spring")
const describe, it, expect = lest.describe, lest.it, lest.expect

const Vector2, Color3, ColorSequenceKeypoint = compat.Vector2, compat.Color3, compat.ColorSequenceKeypoint

const function step<T>(s: scope.Scope, target: T, dt: number?, speed: number?, damping: number?): T
	s:next(dt or 1 / 60)
	return spring(s:key("x"), target, speed, damping)
end

describe("spring", function()
	it("starts at the target on first use", function()
		const s = scope.new()
		expect(step(s, 10)).toBe(10)
	end)

	it("moves towards a new target gradually", function()
		const s = scope.new()
		step(s, 0)
		const value = step(s, 100)
		expect(value > 0 and value < 100).toBe(true)
	end)

	it("settles exactly on the target", function()
		const s = scope.new()
		step(s, 0)
		local value = 0
		for _ = 1, 600 do
			value = step(s, 100)
		end
		expect(value).toBe(100)
	end)

	it("overshoots when underdamped", function()
		const s = scope.new()
		step(s, 0, nil, 10, 0.3)
		local highest = 0
		for _ = 1, 120 do
			highest = math.max(highest, step(s, 100, nil, 10, 0.3))
		end
		expect(highest > 100).toBe(true)
	end)

	it("keeps its momentum when the target changes", function()
		const s = scope.new()
		step(s, 0)
		local value = 0
		for _ = 1, 10 do
			value = step(s, 100)
		end
		-- should keep moving past the target, not stop dead
		const next_value = step(s, value)
		expect(next_value > value).toBe(true)
	end)

	it("moves the same distance at different frame rates", function()
		const fast, slow = scope.new(), scope.new()
		step(fast, 0)
		step(slow, 0)
		local a, b = 0, 0
		for _ = 1, 4 do
			a = step(fast, 100, 1 / 120)
		end
		b = step(slow, 100, 1 / 30)
		expect(math.abs(a - b) < 1e-6).toBe(true)
	end)

	it("springs Vector2s", function()
		const s = scope.new()
		step(s, Vector2.zero)
		const v = step(s, Vector2.new(100, 50))
		expect(v.X > 0 and v.X < 100).toBe(true)
		expect(v.Y > 0 and v.Y < 50).toBe(true)
	end)

	it("returns the exact target colour when at rest", function()
		const s = scope.new()
		const red = Color3.new(1, 0, 0)
		expect(step(s, red)).toBe(red)
	end)

	it("starts a ColorSequenceKeypoint's colour from the previous colour", function()
		const s = scope.new()
		step(s, ColorSequenceKeypoint.new(0, Color3.new(1, 0, 0)))
		const k = step(s, ColorSequenceKeypoint.new(1, Color3.new(0, 0, 1)), 1 / 1000)
		-- one millisecond in, the colour should still be almost pure red
		expect(k.Value.R > 0.9).toBe(true)
		expect(k.Value.B < 0.1).toBe(true)
	end)

	it("restarts when its key is purged", function()
		const s = scope.new()
		step(s, 0)
		step(s, 100)
		s:next(1 / 60)
		s:key("other")
		expect(step(s, 50)).toBe(50)
	end)

	it("errors for a type it can't spring", function()
		const s = scope.new()
		s:next(1 / 60)
		expect((pcall(spring, s:key("x"), "text" :: any))).toBe(false)
	end)
end)

return nil
