const ink = require("../src")

const CELL_COUNT = 100
const CELL_GAP = 2
const CYCLES_PER_SECOND = 8

const COLOR_START = Color3.new(1, 0, 0)
const COLOR_END = Color3.new(0, 0, 1)

return ink.ui_labs_story({
	render = function(properties: ink.StoryProperties)
		const elapsed = ink.timer(properties.scope:key("timer"))

		local rows = table.create<<ink.Composite>>(CELL_COUNT)
		for x = 1, CELL_COUNT do
			local column = table.create<<ink.Composite>>(CELL_COUNT)
			for y = 1, CELL_COUNT do
				const offset = (x * y) / CELL_COUNT ^ 2
				const cell_elapsed = elapsed + offset
				local frame = ink.solid(ink.rect_sized(6, 6))
				frame = ink.tint(frame, COLOR_START:Lerp(COLOR_END, (cell_elapsed * CYCLES_PER_SECOND) % 1))
				frame = ink.rotate(frame, (cell_elapsed * 360) * CYCLES_PER_SECOND)
				column[y] = frame
			end
			rows[x] = ink.h_stack(column, CELL_GAP)
		end

		return ink.v_stack(rows, CELL_GAP)
	end,
})
