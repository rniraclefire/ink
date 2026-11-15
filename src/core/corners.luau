export type Corners = {
	read top_left: number,
	read top_right: number,
	read bottom_left: number,
	read bottom_right: number,
}

const corners = { ZERO = table.freeze({ top_left = 0, top_right = 0, bottom_left = 0, bottom_right = 0 }) :: Corners }

function corners.new(top_left: number, top_right: number, bottom_left: number, bottom_right: number): Corners
	return table.freeze({
		top_left = top_left,
		top_right = top_right,
		bottom_left = bottom_left,
		bottom_right = bottom_right,
	})
end

function corners.all(amount: number): Corners
	return corners.new(amount, amount, amount, amount)
end

function corners.top(amount: number): Corners
	return corners.new(amount, amount, 0, 0)
end

function corners.bottom(amount: number): Corners
	return corners.new(0, 0, amount, amount)
end

function corners.left(amount: number): Corners
	return corners.new(amount, 0, amount, 0)
end

function corners.right(amount: number): Corners
	return corners.new(0, amount, 0, amount)
end

return table.freeze(corners)
