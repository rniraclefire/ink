const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const scope = require("../state/scope")
const timer = require("./timer")

describe("timer", function()
	it("adds up the time of every frame it's requested", function()
		const s = scope.new()
		local elapsed = 0
		for _ = 1, 4 do
			s:next(0.25)
			elapsed = timer(s:key("t"))
		end
		expect(elapsed).toBe(1)
	end)

	it("restarts after its key is purged", function()
		const s = scope.new()
		for _ = 1, 4 do
			s:next(0.25)
			timer(s:key("t"))
		end
		s:next(0.25)
		s:key("other")
		s:next(0.25)
		expect(timer(s:key("t"))).toBe(0.25)
	end)

	it("keeps separate keys independent", function()
		const s = scope.new()
		s:next(0.5)
		timer(s:key("a"))
		s:next(0.5)
		const a = timer(s:key("a"))
		const b = timer(s:key("b"))
		expect(a).toBe(1)
		expect(b).toBe(0.5)
	end)
end)

return nil
