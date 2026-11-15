const primitives = require("../core/primitives")
const pool = require("./pool")

type Target = {
	root: Instance,
	pools: { [primitives.Kind<any, any>]: pool.Pool },
	order: number,
	last_frame: number,
}

const renderer = {}
renderer.__index = renderer

export type Renderer = setmetatable<
	{ default: Target, targets: { [Instance]: Target }, frame: number },
	typeof(renderer)
>

function renderer.new(root: Instance): Renderer
	return setmetatable(
		{ default = { root = root, pools = {}, order = 0, last_frame = 0 }, targets = {}, frame = 0 },
		renderer
	)
end
