const bounds = require("./bounds")
const corners = require("./corners")

export type Gradient = {
	read color: ColorSequence?,
	read transparency: NumberSequence?,
	read rotation: number?,
	read offset: vector?,
	read scale: number?,
	read type: Enum.GradientType?,
	read tile: Enum.GradientTileMode?,
}

export type Stroke = {
	read color: Color3?,
	read transparency: number?,
	read thickness: number?,
	read mode: Enum.ApplyStrokeMode?,
	read gradient: Gradient?,
}

export type Shadow = {
	read color: Color3?,
	read transparency: number?,
	read radius: number?,
	read spread: vector?,
	read inset: boolean?,
	read mode: Enum.ApplyShadowMode?,
	read show_behind_parent: boolean?,
}

export type Placement = {
	read bounds: bounds.Bounds,
	read clip: bounds.Bounds?,
	read rotation: number,
}

export type Appearance = {
	read color: Color3?,
	read transparency: number?,
}

export type Modifiers = {
	read round: corners.Corners?,
	read stroke: Stroke?,
	read gradient: Gradient?,
	read shadow: Shadow?,
}

const styles = {
	EMPTY_APPEARANCE = table.freeze<<Appearance>>({}),
	EMPTY_MODIFIERS = table.freeze<<Modifiers>>({}),
}

return table.freeze(styles)
