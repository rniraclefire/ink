const bounds = require("./bounds")
const primitives = require("./primitives")

export type Composite = {
	read kind: nil,
	read primitives: { read [number]: primitives.Primitive },
	read bounds: bounds.Bounds,
}

export type Compositable = Composite | primitives.Primitive

const composites = {}

function composites.of(c: Compositable): Composite
	return if c.kind ~= nil then table.freeze({ primitives = table.freeze({ c }), bounds = c.bounds }) else c
end

function composites.count_of(c: Compositable): number
	return if c.kind ~= nil then 1 else #c.primitives
end

function composites.primitive_of(c: Compositable, index: number): primitives.Primitive
	return if c.kind ~= nil then c else c.primitives[index]
end

const function next_primitive(c: Compositable, index: number): (number, primitives.Primitive)
	index += 1
	if index > composites.count_of(c) then
		return nil :: any, nil :: any
	end
	return index, composites.primitive_of(c, index)
end

function composites.iter_primitives(c: Compositable): (typeof(next_primitive), Compositable, number)
	return next_primitive, c, 0
end

return table.freeze(composites)
