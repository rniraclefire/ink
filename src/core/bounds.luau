export type Bounds = { read min: vector, read max: vector }

const bounds = {
	ZERO = table.freeze<<Bounds>>({ min = vector.zero, max = vector.zero }),
	UNIT = table.freeze<<Bounds>>({ min = vector.zero, max = vector.one }),
}

function bounds.new(min: vector, max: vector): Bounds
	return table.freeze({ min = min, max = max })
end

function bounds.from_size(width: number, height: number): Bounds
	return bounds.new(vector.zero, vector.create(width, height))
end

function bounds.from_square(length: number): Bounds
	return bounds.new(vector.zero, vector.create(length, length))
end

function bounds.from_rect(x: number, y: number, width: number, height: number): Bounds
	return bounds.new(vector.create(x, y), vector.create(x + width, y + height))
end

function bounds.from_center(center: vector, size: vector): Bounds
	const half_size = size / 2
	return bounds.new(center - half_size, center + half_size)
end

function bounds.size_of(b: Bounds): vector
	return b.max - b.min
end

function bounds.width_of(b: Bounds): number
	return b.max.x - b.min.x
end

function bounds.height_of(b: Bounds): number
	return b.max.y - b.min.y
end

function bounds.center_of(b: Bounds): vector
	const half_size = bounds.size_of(b) / 2
	return b.min + half_size
end

function bounds.floor(b: Bounds): Bounds
	return bounds.new(vector.floor(b.min), vector.floor(b.max))
end

function bounds.ceil(b: Bounds): Bounds
	return bounds.new(vector.ceil(b.min), vector.ceil(b.max))
end

const HALF = vector.create(0.5, 0.5)
function bounds.round(b: Bounds): Bounds
	return bounds.new(vector.floor(b.min + HALF), vector.floor(b.max + HALF))
end

function bounds.inset(b: Bounds, top: number, left: number, bottom: number, right: number): Bounds
	const min = b.min + vector.create(left, top)
	return bounds.new(min, vector.max(b.max - vector.create(right, bottom), min))
end

function bounds.intersect(b: Bounds, other: Bounds): Bounds
	const min = vector.max(b.min, other.min)
	return bounds.new(min, vector.max(vector.min(b.max, other.max), min))
end

function bounds.union(b: Bounds, other: Bounds): Bounds
	return bounds.new(vector.min(b.min, other.min), vector.max(b.max, other.max))
end

function bounds.clamp_point(b: Bounds, point: vector): vector
	return vector.clamp(point, b.min, b.max)
end

function bounds.contains(b: Bounds, point: vector): boolean
	return point.x >= b.min.x and point.x < b.max.x and point.y >= b.min.y and point.y < b.max.y
end

function bounds.equals(b: Bounds, other: Bounds): boolean
	return b.min == other.min and b.max == other.max
end

function bounds.empty(b: Bounds): boolean
	const size = bounds.size_of(b)
	return size.x <= 0 or size.y <= 0
end

function bounds.lerp(b: Bounds, goal: Bounds, alpha: number): Bounds
	return bounds.new(vector.lerp(b.min, goal.min, alpha), vector.lerp(b.max, goal.max, alpha))
end

function bounds.translate(b: Bounds, offset: vector): Bounds
	return bounds.new(b.min + offset, b.max + offset)
end

function bounds.scale(b: Bounds, factor: number | vector, origin: vector?): Bounds
	origin = origin or vector.zero
	return bounds.new(origin + (b.min - origin) * factor, origin + (b.max - origin) * factor)
end

function bounds.align(b: Bounds, container: Bounds, anchor_x: number?, anchor_y: number?): Bounds
	const free = bounds.size_of(container) - bounds.size_of(b)
	const target = vector.create(
		if anchor_x then container.min.x + free.x * anchor_x else b.min.x,
		if anchor_y then container.min.y + free.y * anchor_y else b.min.y
	)
	return bounds.translate(b, target - b.min)
end

function bounds.aspect_fit(container: Bounds, aspect: number, anchor_x: number?, anchor_y: number?): Bounds
	const size = bounds.size_of(container)
	local width, height = size.x, size.x / aspect
	if height > size.y then
		height = size.y
		width = height * aspect
	end
	return bounds.align(bounds.from_size(width, height), container, anchor_x or 0.5, anchor_y or 0.5)
end

function bounds.aspect_cover(container: Bounds, aspect: number, anchor_x: number?, anchor_y: number?): Bounds
	const size = bounds.size_of(container)
	local width, height = size.x, size.x / aspect
	if height < size.y then
		height = size.y
		width = height * aspect
	end
	return bounds.align(bounds.from_size(width, height), container, anchor_x or 0.5, anchor_y or 0.5)
end

function bounds.split_x(b: Bounds, at: number, gap: number?): (Bounds, Bounds)
	const width = bounds.width_of(b)
	const offset = if at < 0 then width + at else at
	const x = math.clamp(b.min.x + offset, b.min.x, b.max.x)
	const right_x = math.min(x + (gap or 0), b.max.x)
	return bounds.new(b.min, vector.create(x, b.max.y)), bounds.new(vector.create(right_x, b.min.y), b.max)
end

function bounds.split_y(b: Bounds, at: number, gap: number?): (Bounds, Bounds)
	const height = bounds.height_of(b)
	const offset = if at < 0 then height + at else at
	const y = math.clamp(b.min.y + offset, b.min.y, b.max.y)
	const bottom_y = math.min(y + (gap or 0), b.max.y)
	return bounds.new(b.min, vector.create(b.max.x, y)), bounds.new(vector.create(b.min.x, bottom_y), b.max)
end

return table.freeze(bounds)
