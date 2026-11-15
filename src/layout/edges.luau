const edges = {}

function edges.new(top: number?, left: number?, bottom: number?, right: number?): (number, number, number, number)
	return top or 0, left or 0, bottom or 0, right or 0
end

function edges.all(amount: number)
	return edges.new(amount, amount, amount, amount)
end

function edges.top(amount: number)
	return edges.new(amount, 0, 0, 0)
end

function edges.left(amount: number)
	return edges.new(0, amount, 0, 0)
end

function edges.bottom(amount: number)
	return edges.new(0, 0, amount, 0)
end

function edges.right(amount: number)
	return edges.new(0, 0, 0, amount)
end

function edges.xy(amount_x: number, amount_y: number)
	return edges.new(amount_y, amount_x, amount_y, amount_x)
end

function edges.horizontal(amount: number)
	return edges.new(0, amount, 0, amount)
end

function edges.vertical(amount: number)
	return edges.new(amount, 0, amount, 0)
end

function edges.zero()
	return edges.new()
end

return table.freeze(edges)
