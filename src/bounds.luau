const bounds = {
	ZERO = table.freeze({ min = vector.zero, max = vector.zero }),
	UNIT = table.freeze({ min = vector.zero, max = vector.one }),
}

export type Bounds = { read min: vector, read max: vector }

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

function bounds.size_of(self: Bounds): vector
	return self.max - self.min
end

function bounds.width_of(self: Bounds): number
	return self.max.x - self.min.x
end

function bounds.height_of(self: Bounds): number
	return self.max.y - self.min.y
end

function bounds.center_of(self: Bounds): vector
	const half_size = bounds.size_of(self) / 2
	return self.min + half_size
end

function bounds.floor(self: Bounds): Bounds
	return bounds.new(vector.floor(self.min), vector.floor(self.max))
end

function bounds.ceil(self: Bounds): Bounds
	return bounds.new(vector.ceil(self.min), vector.ceil(self.max))
end

const HALF = vector.create(0.5, 0.5)
function bounds.round(self: Bounds): Bounds
	return bounds.new(vector.floor(self.min + HALF), vector.floor(self.max + HALF))
end

function bounds.inset(self: Bounds, top: number, left: number, bottom: number, right: number): Bounds
	const min = self.min + vector.create(left, top)
	return bounds.new(min, vector.max(self.max - vector.create(right, bottom), min))
end

function bounds.intersect(self: Bounds, other: Bounds): Bounds
	const min = vector.max(self.min, other.min)
	return bounds.new(min, vector.max(vector.min(self.max, other.max), min))
end

function bounds.union(self: Bounds, other: Bounds): Bounds
	return bounds.new(vector.min(self.min, other.min), vector.max(self.max, other.max))
end

function bounds.clamp_point(self: Bounds, point: vector): vector
	return vector.clamp(point, self.min, self.max)
end

function bounds.contains(self: Bounds, point: vector): boolean
	return point.x >= self.min.x and point.x < self.max.x and point.y >= self.min.y and point.y < self.max.y
end

function bounds.equals(self: Bounds, other: Bounds): boolean
	return self.min == other.min and self.max == other.max
end

function bounds.empty(self: Bounds): boolean
	const size = bounds.size_of(self)
	return size.x <= 0 or size.y <= 0
end

function bounds.lerp(self: Bounds, goal: Bounds, alpha: number): Bounds
	return bounds.new(vector.lerp(self.min, goal.min, alpha), vector.lerp(self.max, goal.max, alpha))
end

function bounds.translate(self: Bounds, offset: vector): Bounds
	return bounds.new(self.min + offset, self.max + offset)
end

function bounds.scale(self: Bounds, factor: number | vector, origin: vector?): Bounds
	origin = origin or vector.zero
	return bounds.new(origin + (self.min - origin) * factor, origin + (self.max - origin) * factor)
end

function bounds.align(self: Bounds, container: Bounds, anchor_x: number?, anchor_y: number?): Bounds
	const free = bounds.size_of(container) - bounds.size_of(self)
	const target = vector.create(
		if anchor_x then container.min.x + free.x * anchor_x else self.min.x,
		if anchor_y then container.min.y + free.y * anchor_y else self.min.y
	)
	return bounds.translate(self, target - self.min)
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

function bounds.split_x(self: Bounds, at: number, gap: number?): (Bounds, Bounds)
	const width = bounds.width_of(self)
	const offset = if at < 0 then width + at else at
	const x = math.clamp(self.min.x + offset, self.min.x, self.max.x)
	const right_x = math.min(x + (gap or 0), self.max.x)
	return bounds.new(self.min, vector.create(x, self.max.y)), bounds.new(vector.create(right_x, self.min.y), self.max)
end

function bounds.split_y(self: Bounds, at: number, gap: number?): (Bounds, Bounds)
	const height = bounds.height_of(self)
	const offset = if at < 0 then height + at else at
	const y = math.clamp(self.min.y + offset, self.min.y, self.max.y)
	const bottom_y = math.min(y + (gap or 0), self.max.y)
	return bounds.new(self.min, vector.create(self.max.x, y)), bounds.new(vector.create(self.min.x, bottom_y), self.max)
end

return table.freeze(bounds)
