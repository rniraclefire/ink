local scope = require("./runtime/scope")

-- Utility

export type Cleanup = () -> ()

export type Pack<T = unknown> = { [number]: T, n: number }

-- Styling

export type RoundStyle = { tl: number?, tr: number?, bl: number?, br: number? }

export type TextStyle = { size: number, font: Enum.Font }

export type ImageStyle = {
	scale_type: Enum.ScaleType?,
	slice_center: Rect?,
	slice_scale: number?,
	rect_offset: Vector2?,
	rect_size: Vector2?,
	resample: Enum.ResamplerMode?,
	tile_size: UDim2?,
}

-- Composites

export type Primitive = {
	bounds: Rect,
	clip: Rect?,
	color: Color3?,
	transparency: number?,
	round: RoundStyle?,
	rotation: number?,
	text: string?,
	text_style: TextStyle?,
	image: string?,
	image_style: ImageStyle?,
	hotspot: Hotspot?,
	hotspot_wheel: boolean?,
}

export type Composite = { primitives: { Primitive }, bounds: Rect }

-- Runtime

export type Scope = scope.Scope

export type IntentSource = {
	read InputBegan: RBXScriptSignal<InputObject>,
	read InputChanged: RBXScriptSignal<InputObject>,
	read InputEnded: RBXScriptSignal<InputObject>,
}

export type Intent = {
	pointer: Vector2,
	pointer_delta: Vector2,
	down: boolean,
	pressed: boolean,
	released: boolean,
	wheel: number,
	keys_held: { [Enum.KeyCode]: boolean },
	keys_pressed: { [Enum.KeyCode]: boolean },
}

export type IntentState = { hotspots: { Primitive }, active: Hotspot? }

export type Hotspot = {
	state: Enum.GuiState,
	clicked: boolean,
	wheel: number,
	drag: Vector2,
	pointer: Vector2,
	bounds: Rect,
}

export type HotspotOptions = { wheel: boolean? }

export type function ProcessControls(controls: type): type
	const CONTROL_VALUE = types.singleton("ControlValue")

	if controls.tag ~= "table" then
		return controls
	end

	const result = types.newtable()
	for key, control in controls:properties() do
		local control_value = control.read
		if control.read and control.read.tag == "table" then
			control_value = control.read:readproperty(CONTROL_VALUE)
		end
		result:setreadproperty(key, control_value)
	end

	return result
end

export type StoryProperties<C = nil> = {
	controls: ProcessControls<C>,
	target: GuiObject,
	target_bounds: Rect,
	scope: scope.Scope,
}

export type Story<C = nil> = {
	name: string?,
	summary: string?,
	cleanup: Cleanup?,
	controls: C?,
	render: (properties: StoryProperties<C>) -> Composite,
}

return nil
