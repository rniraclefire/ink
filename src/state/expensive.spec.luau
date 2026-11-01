const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const expensive = require("./expensive")
const scope = require("./scope")

describe("expensive", function()
	it("computes on first use", function()
		const s = scope.new()
		expect(expensive(s, function(_, a: number, b: number)
			return a + b
		end, 2, 3)).toBe(5)
	end)

	it("doesn't recompute when the arguments are the same", function()
		const s = scope.new()
		local calls = 0
		const function compute(_, a: number)
			calls += 1
			return a * 2
		end
		expensive(s, compute, 4)
		s:next(1 / 60)
		const result = expensive(s, compute, 4)
		expect(calls).toBe(1)
		expect(result).toBe(8)
	end)

	it("recomputes when any argument changes", function()
		const s = scope.new()
		local calls = 0
		const function compute(_, a: number, b: number)
			calls += 1
			return a + b
		end
		expensive(s, compute, 1, 2)
		expensive(s, compute, 1, 3)
		expect(calls).toBe(2)
	end)

	it("recomputes when the number of arguments changes", function()
		const s = scope.new()
		local calls = 0
		const function compute(_, ...: any)
			calls += 1
			return select("#", ...)
		end
		expensive(s, compute, 1)
		expect(expensive(s, compute, 1, nil)).toBe(2)
		expect(calls).toBe(2)
	end)

	it("returns every value the computation returns", function()
		const s = scope.new()
		const function compute(_, a: number)
			return a, a + 1, a + 2
		end
		const x, y, z = expensive(s, compute, 1)
		expect(x).toBe(1)
		expect(y).toBe(2)
		expect(z).toBe(3)
		s:next(1 / 60)
		const y1, y2, z2 = expensive(s, compute, 1)
		expect(y1).toBe(1)
		expect(y2).toBe(2)
		expect(z2).toBe(3)
	end)

	it("compares tables by reference", function()
		const s = scope.new()
		local calls = 0
		const function compute(_, t: {})
			calls += 1
			return t
		end
		const shared = {}
		expensive(s, compute, shared)
		expensive(s, compute, shared)
		expensive(s, compute, {})
		expect(calls).toBe(2)
	end)

	it("passes its own scope to the computation", function()
		const s = scope.new()
		local received
		expensive(s, function(inner)
			received = inner
			return nil
		end)
		expect(received).toBe(s)
	end)
end)

return nil
