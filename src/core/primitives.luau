const bounds = require("../bounds")

export type Write = (instance: Instance, property: string, value: unknown) -> ()

export type Kind<P, I = Instance> = {
	name: string,
	instance_class: string,
	init: (instance: I) -> (),
	update: (instance: I, props: P, write: Write) -> (),
}

export type Style = {
	color: Color3?,
	transparency: number?,
}

export type Primitive<P = any> = {
	kind: Kind<P>,
	bounds: bounds.Bounds,
	style: Style,
	props: P,
}

return nil
