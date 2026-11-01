const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const distribute = require("./distribute")

const function expect_lengths(actual: { number }, expected: { number })
	expect(#actual).toBe(#expected)
	for i, value in expected do
		expect(actual[i]).toBe(value)
	end
end

describe("distribute", function()
	it("passes fixed lengths through", function()
		expect_lengths(distribute(500, { 100, 200 }), { 100, 200 })
	end)

	it("splits the container evenly between equal fractions", function()
		expect_lengths(distribute(300, { { fr = 1 }, { fr = 1 }, { fr = 1 } }), { 100, 100, 100 })
	end)

	it("splits the container by fraction weight", function()
		expect_lengths(distribute(300, { { fr = 1 }, { fr = 2 } }), { 100, 200 })
	end)

	it("gives fractions the space left after fixed lengths", function()
		expect_lengths(distribute(400, { 100, { fr = 1 }, { fr = 2 } }), { 100, 100, 200 })
	end)

	it("subtracts one gap between each pair of items", function()
		expect_lengths(distribute(320, { { fr = 1 }, { fr = 1 }, { fr = 1 } }, 10), { 100, 100, 100 })
	end)

	it("doesn't subtract a gap for a single item", function()
		expect_lengths(distribute(100, { { fr = 1 } }, 10), { 100 })
	end)

	it("gives fractions zero when fixed lengths overflow", function()
		expect_lengths(distribute(100, { 150, { fr = 1 } }), { 150, 0 })
	end)

	it("returns an empty list for no lengths", function()
		expect_lengths(distribute(100, {}), {})
	end)
end)

return nil
