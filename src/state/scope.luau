type Shared = { frame: number, dt: number, time: number }

--- Stores state between frames at named keys. Unused values are cleared next frame.
const scope = {}
scope.__index = scope

export type Scope = setmetatable<{
	shared: Shared,
	flipped_on: number,
	previous: { [string]: any },
	current: { [string]: any },
	value: unknown,
	pending: unknown,
	pending_frame: number?,
	parent: Scope?,
}, typeof(scope)>

const function new_scope(shared: Shared, parent: Scope?): Scope
	return setmetatable({
		shared = shared,
		flipped_on = -1,
		previous = {},
		current = {},
		value = nil,
		pending = nil,
		pending_frame = nil,
		parent = parent,
	}, scope)
end

--- Returns a new scope.
function scope.new(): Scope
	return new_scope({ frame = 0, dt = 0, time = 0 })
end

function scope.next(self: Scope, dt: number)
	const clock = self.shared
	clock.frame += 1
	clock.dt = dt
	clock.time += dt
end

const function flip(self: Scope)
	const frame = self:frame()
	if self.flipped_on ~= frame then
		self.flipped_on = frame
		const old = self.previous
		self.previous = self.current
		self.current = old
		table.clear(old)
	end
end

function scope.key(self: Scope, name: string): Scope
	flip(self)
	local child = self.current[name]
	if child == nil then
		child = self.previous[name] or new_scope(self.shared, self)
		self.current[name] = child
	end
	return child
end

function scope.once<T>(self: Scope, init: () -> T): T
	if self.value == nil then
		self.value = init()
	end
	return self.value :: T
end

function scope.set<T>(self: Scope, value: T)
	self.pending = value
	self.pending_frame = self:frame()
end

function scope.get<T>(self: Scope, default: T): T
	if self.pending_frame and self.pending_frame < self:frame() then
		self.value = self.pending
		self.pending, self.pending_frame = nil, nil
	end
	const value = self.value
	return if value == nil then default else value :: T
end

function scope.frame(self: Scope): number
	return self.shared.frame
end

function scope.dt(self: Scope): number
	return self.shared.dt
end

function scope.time(self: Scope): number
	return self.shared.time
end

return table.freeze(scope)
