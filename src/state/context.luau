const types = require("../types")

const WEAK_KEYS_METATABLE = { __mode = "k" }

const context = {}
context.__index = context

--- Contexts can provide a value to a scope, including scopes keyed inside it.
export type Context<T> = setmetatable<{
	default: T,
	provided: { [types.Scope]: T },
	provided_frame: { [types.Scope]: number },
}, typeof(context)>

--- Returns a new context with the default value.
function context.new<T>(default: T): Context<T>
	return setmetatable({
		default = default,
		provided = setmetatable({}, WEAK_KEYS_METATABLE),
		provided_frame = setmetatable({}, WEAK_KEYS_METATABLE),
	}, context)
end

--- Provides a value to a scope, including scopes keyed inside it.
function context.provide<T>(self: Context<T>, scope: types.Scope, value: T): T
	self.provided[scope] = value
	self.provided_frame[scope] = scope:frame()
	return value
end

--- Clears the value provided to a scope, but does not touch scopes keyed inside it.
function context.clear<T>(self: Context<T>, scope: types.Scope)
	self.provided[scope] = nil
	self.provided_frame[scope] = nil
end

--- Returns the provided value from the closest scope, or the default value where none are provided.
function context.get<T>(self: Context<T>, scope: types.Scope): T
	const frame = scope:frame()
	local current: types.Scope? = scope
	while current do
		if self.provided_frame[current] == frame then
			return self.provided[current]
		end
		current = current.parent
	end
	return self.default
end

--- Destroys the context, clearing it's provided scopes.
function context.destroy<T>(self: Context<T>)
	table.clear(self.provided)
	table.clear(self.provided_frame)
end

return table.freeze(context)
