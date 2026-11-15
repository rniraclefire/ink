const edges = {}

function edges.sides(top: number?, left: number?, bottom: number?, right: number?): (number, number, number, number)
	return top or 0, left or 0, bottom or 0, right or 0
end

function edges.all(amount: number)
	return edges.sides(amount, amount, amount, amount)
end

function edges.top(amount: number)
	return edges.sides(amount, 0, 0, 0)
end

function edges.left(amount: number)
	return edges.sides(0, amount, 0, 0)
end

function edges.bottom(amount: number)
	return edges.sides(0, 0, amount, 0)
end

function edges.right(amount: number)
	return edges.sides(0, 0, 0, amount)
end

function edges.xy(x: number, y: number)
	return edges.sides(y, x, y, x)
end

function edges.horizontal(amount: number)
	return edges.xy(amount, 0)
end

function edges.vertical(amount: number)
	return edges.xy(0, amount)
end

function edges.zero()
	return edges.sides(0, 0, 0, 0)
end

return table.freeze(edges)
