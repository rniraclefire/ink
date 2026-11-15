const bounds = require("@self/core/bounds")
const color = require("@self/styles/color")
const compose = require("@self/layout/compose")
const compose_bounded = require("@self/layout/compose_bounded")
const composites = require("@self/core/composites")
const corners = require("@self/core/corners")
const edges = require("@self/core/edges")
const fade = require("@self/styles/fade")
const primitives = require("@self/core/primitives")
const solid = require("@self/primitives/solid")
const styles = require("@self/core/styles")
const version = require("@self/version")

export type Bounds = bounds.Bounds
export type Corners = corners.Corners

export type Kind<P = any, I = any> = primitives.Kind<P, I>
export type Primitive<P = any> = primitives.Primitive<P>
export type Composite = composites.Composite
export type Compositable = composites.Compositable

export type Gradient = styles.Gradient
export type Shadow = styles.Shadow
export type Stroke = styles.Stroke
export type Placement = styles.Placement
export type Appearance = styles.Appearance
export type Modifiers = styles.Modifiers

const ink = {}
ink.version = version

-- Core
ink.bounds = bounds
ink.corners = corners
ink.composites = composites
ink.primitives = primitives
ink.styles = styles
ink.edges = edges

-- Primitives
ink.solid = solid

-- Layouts
ink.compose = compose
ink.compose_bounded = compose_bounded

-- Styles
ink.color = color
ink.fade = fade

return table.freeze(ink)
