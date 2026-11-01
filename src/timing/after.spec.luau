const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const after = require("./after")
const scope = require("../state/scope")

const function step(s: scope.Scope, dt: number, duration: number): boolean
	s:next(dt)
	return after(s:key("after"), duration)
end

describe("after", function()
	it("is false before the duration has elapsed", function()
		const s = scope.new()
		expect(step(s, 0.25, 1)).toBe(false) -- 0.25s
		expect(step(s, 0.25, 1)).toBe(false) -- 0.5s
		expect(step(s, 0.25, 1)).toBe(false) -- 0.75s
	end)

	it("is true on the frame the duration is reached", function()
		const s = scope.new()
		for _ = 1, 3 do
			step(s, 0.25, 1)
		end
		expect(step(s, 0.25, 1)).toBe(true) -- 1.0s
	end)

	it("stays true afterwards", function()
		const s = scope.new()
		for _ = 1, 4 do
			step(s, 0.25, 1)
		end
		expect(step(s, 0.25, 1)).toBe(true)
		expect(step(s, 0.25, 1)).toBe(true)
	end)

	it("restarts when the duration changes", function()
		const s = scope.new()
		for _ = 1, 4 do
			step(s, 0.25, 1)
		end
		expect(step(s, 0.25, 2)).toBe(false)
	end)

	it("restarts when its key is purged", function()
		const s = scope.new()
		for _ = 1, 4 do
			step(s, 0.25, 1)
		end
		s:next(0.25)
		s:key("other")
		expect(step(s, 0.25, 1)).toBe(false)
	end)
end)

return nil
