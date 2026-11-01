const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const compat = require("../compat")
const task = compat.task

const async = require("./async")
const scope = require("./scope")

describe("async", function()
	it("returns the default before the result is ready", function()
		const s = scope.new()
		expect(async(s, "loading", function(_, n: number)
			task.wait(0.1)
			return `done {n}`
		end, 1)).toBe("loading")
	end)

	it("returns the result once the computation finishes", function()
		const s = scope.new()
		const function compute(_, n: number)
			return n * 2
		end
		async(s, 0, compute, 21)
		task.wait()
		s:next(1 / 60)
		expect(async(s, 0, compute, 21)).toBe(42)
	end)

	it("doesn't restart when the arguments stay the same", function()
		const s = scope.new()
		local calls = 0
		const function compute(_, n: number)
			calls += 1
			return n
		end
		async(s, 0, compute, 1)
		task.wait()
		async(s, 0, compute, 1)
		task.wait()
		expect(calls).toBe(1)
	end)

	it("keeps the previous result while new arguments are loading", function()
		const s = scope.new()
		const function compute(_, n: number)
			if n == 2 then
				task.wait(0.1)
			end
			return n
		end
		async(s, 0, compute, 1)
		task.wait()
		expect(async(s, 0, compute, 2)).toBe(1)
	end)

	it("publishes partial values with become", function()
		const s = scope.new()
		const function compute(become: (string) -> ())
			become("halfway")
			task.wait(0.1)
			return "done"
		end
		async(s, "start", compute)
		task.wait()
		expect(async(s, "start", compute)).toBe("halfway")
	end)

	it("ignores results from arguments that have since changed", function()
		const s = scope.new()
		const function compute(_, n: number)
			task.wait(if n == 1 then 0.2 else 0)
			return n
		end
		async(s, 0, compute, 1)
		task.wait()
		async(s, 0, compute, 2)
		task.wait(0.3)
		expect(async(s, 0, compute, 2)).toBe(2)
	end)
end)

return nil
