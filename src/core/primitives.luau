const bounds = require("./bounds")
const styles = require("./styles")

export type Write = (instance: Instance, property: string, value: unknown) -> ()

export type Kind<P, I = Instance> = {
	read name: string,
	read instance_class: string,
	read init: (instance: I, write: Write) -> (),
	read update: (instance: I, props: P, appearance: styles.Appearance, write: Write) -> (),
}

export type Primitive<P = any> = {
	read kind: Kind<P, any>,
	read bounds: bounds.Bounds,
	read clip: bounds.Bounds?,
	read rotation: number?,
	read appearance: styles.Appearance,
	read modifiers: styles.Modifiers,
	read props: P,
}

const primitives = {}

function primitives.new<P>(
	kind: Kind<P, any>,
	b: bounds.Bounds,
	props: P,
	appearance: styles.Appearance?,
	modifiers: styles.Modifiers?
): Primitive<P>
	return table.freeze({
		kind = kind,
		bounds = b,
		clip = nil,
		rotation = nil,
		appearance = appearance or styles.EMPTY_APPEARANCE,
		modifiers = modifiers or styles.EMPTY_MODIFIERS,
		props = props,
	})
end

function primitives.with_bounds<P>(p: Primitive<P>, b: bounds.Bounds): Primitive<P>
	return table.freeze({
		kind = p.kind,
		bounds = b,
		clip = p.clip,
		rotation = p.rotation,
		appearance = p.appearance,
		modifiers = p.modifiers,
		props = p.props,
	})
end

function primitives.with_placement<P>(
	p: Primitive<P>,
	b: bounds.Bounds,
	clip: bounds.Bounds?,
	rotation: number?
): Primitive<P>
	return table.freeze({
		kind = p.kind,
		bounds = b,
		clip = clip,
		rotation = rotation,
		appearance = p.appearance,
		modifiers = p.modifiers,
		props = p.props,
	})
end

function primitives.with_appearance<P>(p: Primitive<P>, partial: styles.Appearance): Primitive<P>
	const merged = table.clone(p.appearance)
	for key, value in partial :: { [string]: unknown } do
		(merged :: { [string]: unknown })[key] = value
	end

	return table.freeze({
		kind = p.kind,
		bounds = p.bounds,
		clip = p.clip,
		rotation = p.rotation,
		appearance = table.freeze(merged),
		modifiers = p.modifiers,
		props = p.props,
	})
end

function primitives.with_modifiers<P>(p: Primitive<P>, partial: styles.Modifiers): Primitive<P>
	const merged = table.clone(p.modifiers)
	for key, value in partial :: { [string]: unknown } do
		(merged :: { [string]: unknown })[key] = value
	end

	return table.freeze({
		kind = p.kind,
		bounds = p.bounds,
		clip = p.clip,
		rotation = p.rotation,
		appearance = p.appearance,
		modifiers = table.freeze(merged),
		props = p.props,
	})
end

function primitives.map<A...>(ps: { Primitive }, transform: (Primitive, A...) -> Primitive, ...: A...): { Primitive }
	const result = table.create<<Primitive>>(#ps)
	for index, p in ps do
		result[index] = transform(p, ...)
	end
	return result
end

function primitives.filter(ps: { Primitive }, predicate: (Primitive) -> boolean): { Primitive }
	const result = {}
	for _, p in ps do
		if predicate(p) then
			table.insert(result, p)
		end
	end
	return result
end

return table.freeze(primitives)
