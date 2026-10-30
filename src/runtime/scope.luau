type Shared = { frame: number, dt: number, time: number }

const scope = {}
scope.__index = scope

--[=[
	@class Scope
	Represents an immediate-mode hierarchical state container.
	State is indexed under persistent string keys between render frames.
	Scopes retain children visited in the current frame and discard unvisited
	children from previous frames (double-buffered generational GC).
]=]
export type Scope = setmetatable<{
	shared: Shared,
	flipped_on: number,
	previous: { [string]: any },
	current: { [string]: any },
	value: unknown,
	pending: unknown,
	pending_frame: number?,
}, typeof(scope)>

const function new_scope(shared: Shared): Scope
	return setmetatable(
		{
			shared = shared,
			flipped_on = -1,
			previous = {},
			current = {},
			value = nil,
			pending = nil,
			pending_frame = nil,
		},
		scope
	)
end

--- Creates a new root Scope instance with frame counters initialized to 0.
function scope.new(): Scope
	return new_scope({ frame = 0, dt = 0, time = 0 })
end

--- Advances the clock by `dt` seconds and increments the current frame count.
--- Must be invoked once at the beginning of each frame.
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
		local old = self.previous
		self.previous = self.current
		self.current = old
		table.clear(old)
	end
end

--- Retrieves or creates a persistent child scope keyed by `name`.
--- Unvisited keys from the prior frame are cleared on the subsequent flip.
function scope.key(self: Scope, name: string): Scope
	flip(self)
	local child = self.current[name]
	if child == nil then
		child = self.previous[name] or new_scope(self.shared)
		self.current[name] = child
	end
	return child
end

--- Initializes and memoizes a value for the lifetime of this scope.
--- Subsequent calls within the same scope return the cached value.
function scope.once<T>(self: Scope, init: () -> T): T
	if self.value == nil then
		self.value = init()
	end
	return self.value :: T
end

--- Queues a pending value update to become visible on the next frame (frame + 1).
--- Reads during the current frame via `get` continue returning the previous value.
function scope.set<T>(self: Scope, value: T)
	self.pending = value
	self.pending_frame = self:frame()
end

--- Returns the current committed value for this scope, or `default` if unassigned.
--- If a pending value was set in a previous frame, it is committed here.
function scope.get<T>(self: Scope, default: T): T
	if self.pending_frame and self.pending_frame < self:frame() then
		self.value = self.pending
		self.pending, self.pending_frame = nil, nil
	end
	const value = self.value
	return if value == nil then default else value :: T
end

--- Returns the global frame index.
function scope.frame(self: Scope): number
	return self.shared.frame
end

--- Returns the delta time of the current frame in seconds.
function scope.dt(self: Scope): number
	return self.shared.dt
end

--- Returns total elapsed simulation time in seconds.
function scope.time(self: Scope): number
	return self.shared.time
end

return table.freeze(scope)
