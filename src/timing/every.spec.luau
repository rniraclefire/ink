const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const every = require("./every")
const scope = require("../state/scope")

const function run(frames: number, dt: number, duration: number): { number }
	const s = scope.new()
	const fired = {}
	for frame = 1, frames do
		s:next(dt)
		if every(s:key("every"), duration) then
			table.insert(fired, frame)
		end
	end
	return fired
end

describe("every", function()
	it("doesn't fire before the first interval", function()
		expect(#run(1, 0.25, 0.5)).toBe(0)
	end)

	it("fires on the frame each interval is reached", function()
		const fired = run(6, 0.25, 0.5) -- 0.5s, 1.0s, 1.5s
		expect(#fired).toBe(3)
		expect(fired[1]).toBe(2)
		expect(fired[2]).toBe(4)
		expect(fired[3]).toBe(6)
	end)

	it("keeps a steady period over many intervals", function()
		const fired = run(40, 0.25, 1) -- 10 seconds
		expect(#fired).toBe(10)
		for i = 2, #fired do
			expect(fired[i] - fired[i - 1]).toBe(4)
		end
	end)
end)

return nil
