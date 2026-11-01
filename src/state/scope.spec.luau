const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const scope = require("./scope")

describe("scope", function()
	describe("clock", function()
		it("starts at frame 0 with no time", function()
			const s = scope.new()
			expect(s:frame()).toBe(0)
			expect(s:dt()).toBe(0)
			expect(s:time()).toBe(0)
		end)

		it("advances the frame, dt and time with next", function()
			const s = scope.new()
			s:next(0.25)
			s:next(0.5)
			expect(s:frame()).toBe(2)
			expect(s:dt()).toBe(0.5)
			expect(s:time()).toBe(0.75)
		end)

		it("shares the clock with keyed scopes", function()
			const s = scope.new()
			const child = s:key("child")
			s:next(0.5)
			expect(child:frame()).toBe(1)
			expect(child:dt()).toBe(0.5)
		end)
	end)

	describe("key", function()
		it("returns the same scope for the same name in one frame", function()
			const s = scope.new()
			expect(s:key("a")).toBe(s:key("a"))
		end)

		it("returns different scopes for different names", function()
			const s = scope.new()
			expect(s:key("a") ~= s:key("b")).toBe(true)
		end)

		it("keeps a scope that is requested every frame", function()
			const s = scope.new()
			const first = s:key("a")
			s:next(1 / 60)
			expect(s:key("a")).toBe(first)
			s:next(1 / 60)
			expect(s:key("a")).toBe(first)
		end)

		it("purges a scope that isn't requested for a frame", function()
			const s = scope.new()
			const first = s:key("a")
			s:next(1 / 60)
			s:key("other")
			s:next(1 / 60)
			expect(s:key("a") ~= first).toBe(true)
		end)

		it("keeps children of a scope that was visited but didn't key them", function()
			const s = scope.new()
			const inner = s:key("a"):key("b")
			s:next(1 / 60)
			s:key("a") -- e.g. an expensive() cache hit skipped the inner key
			s:next(1 / 60)
			expect(s:key("a"):key("b")).toBe(inner)
		end)

		it("sets the parent of keyed scopes", function()
			const s = scope.new()
			expect(s:key("a").parent).toBe(s)
		end)
	end)

	describe("once", function()
		it("runs the initialiser only once", function()
			const s = scope.new()
			local calls = 0
			const function init()
				calls += 1
				return {}
			end
			const a = s:once(init)
			const b = s:once(init)
			expect(calls).toBe(1)
			expect(a).toBe(b)
		end)

		it("runs again after the scope is purged", function()
			const s = scope.new()
			local calls = 0
			const function init()
				calls += 1
				return {}
			end
			s:key("a"):once(init)
			s:next(1 / 60)
			s:key("other")
			s:next(1 / 60)
			s:key("a"):once(init)
			expect(calls).toBe(2)
		end)
	end)

	describe("get and set", function()
		it("returns the default before anything is set", function()
			expect(scope.new():get(42)).toBe(42)
		end)

		it("doesn't apply a set value until the next frame", function()
			const s = scope.new()
			s:set(5)
			expect(s:get(0)).toBe(0)
			s:next(1 / 60)
			expect(s:get(0)).toBe(5)
		end)

		it("applies the last value set in a frame", function()
			const s = scope.new()
			s:set(1)
			s:set(2)
			s:next(1 / 60)
			expect(s:get(0)).toBe(2)
		end)

		it("keeps the value in later frames", function()
			const s = scope.new()
			s:set(5)
			s:next(1 / 60)
			s:next(1 / 60)
			expect(s:get(0)).toBe(5)
		end)
	end)
end)

return nil
