const context = require("@self/state/context")
const types = require("@self/types")

export type Primitive = types.Primitive
export type Composite = types.Composite
export type RoundStyle = types.RoundStyle
export type TextStyle = types.TextStyle
export type ImageStyle = types.ImageStyle
export type Length = types.Length

export type Intent = types.Intent
export type IntentState = types.IntentState
export type Hotspot = types.Hotspot
export type HotspotOptions = types.HotspotOptions

export type Scope = types.Scope
export type Context<T> = context.Context<T>
export type Story<C = nil> = types.Story<C>
export type StoryProperties<C = nil> = types.StoryProperties<C>

--- @class ink
--- Zero-hierarchy immediate-mode UI library for Roblox and Vortex.
const ink = table.freeze({
	version = require("@self/version"),

	-- Composites
	solid = require("@self/composites/solid"),
	text = require("@self/composites/text"),
	image = require("@self/composites/image"),
	hotspot = require("@self/composites/hotspot"),
	compose = require("@self/layout/compose"),

	-- Layouts
	translate = require("@self/layout/translate"),
	align = require("@self/layout/align"),
	h_stack = require("@self/layout/h_stack"),
	v_stack = require("@self/layout/v_stack"),
	masonry = require("@self/layout/masonry"),
	visible_range = require("@self/layout/visible_range"),
	pad_all = require("@self/layout/pad_all"),
	pad_sides = require("@self/layout/pad_sides"),
	pad_xy = require("@self/layout/pad_xy"),
	clip = require("@self/layout/clip"),

	-- Styling
	tint = require("@self/styling/tint"),
	rotate = require("@self/styling/rotate"),
	round = require("@self/styling/round"),

	-- Rects
	aspect_cover = require("@self/rects/aspect_cover"),
	aspect_fit = require("@self/rects/aspect_fit"),
	inset_rect = require("@self/rects/inset_rect"),
	inset_rect_sides = require("@self/rects/inset_rect_sides"),
	inset_rect_xy = require("@self/rects/inset_rect_xy"),
	intersect_rects = require("@self/rects/intersect_rects"),
	is_equal_rects = require("@self/rects/is_equal_rects"),
	is_in_rect = require("@self/rects/is_in_rect"),
	rect = require("@self/rects/rect"),
	rect_sized = require("@self/rects/rect_sized"),
	union_rects = require("@self/rects/union_rects"),
	distribute = require("@self/rects/distribute"),

	-- Animation
	lerp = require("@self/animation/lerp"),
	spring = require("@self/animation/spring"),
	tween = require("@self/animation/tween"),
	color = require("@self/animation/color"),

	-- Timing
	timer = require("@self/timing/timer"),
	after = require("@self/timing/after"),
	every = require("@self/timing/every"),

	-- State
	async = require("@self/state/async"),
	context = require("@self/state/context").new,
	scope = require("@self/state/scope").new,
	expensive = require("@self/state/expensive"),

	-- Runtime
	ui_labs_story = require("@self/runtime/ui_labs_story"),
	update_intent_state = require("@self/runtime/update_intent_state"),
	gui_object_renderer = require("@self/runtime/gui_object_renderer"),
	input_source_intent = require("@self/runtime/input_source_intent"),
})

return ink
