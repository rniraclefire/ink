--- Returns the range of items which are visible for a given scroll offset, as seen in scrolling views.
const function visible_range(offset: number, view_height: number, item_height: number, count: number): (number, number)
	const first = math.max(1, math.floor(offset / item_height) + 1)
	const last = math.min(count, math.ceil((offset + view_height) / item_height))
	return first, last
end

return visible_range
