local compat = require("../compat")
local is_equal_rects = require("../rects/is_equal_rects")
local types = require("../types")
local Color3, Enum, Vector2, UDim, UDim2 = compat.Color3, compat.Enum, compat.Vector2, compat.UDim, compat.UDim2

type PoolInstance = {
	instance: any,
	written: { [string]: unknown },
	modifiers: { [string]: PoolInstance },
	text_field_submitted: boolean?,
	text_field_connection: RBXScriptConnection?,
}

type Pool = { instances: { PoolInstance }, used: number }

const function pool_instance(class_name: string): PoolInstance
	return {
		instance = Instance.new(class_name),
		written = {},
		modifiers = {},
		text_field_submitted = false,
		text_field_connection = nil,
	}
end

const function destroy_pool_instance(pooled: PoolInstance)
	if pooled.text_field_connection then
		pooled.text_field_connection:Disconnect()
	end
	if pooled.instance:IsA("TextBox") and pooled.instance:IsFocused() then
		pooled.instance:ReleaseFocus()
	end
	pooled.instance:Destroy()
end

const function write(pool: PoolInstance, property: string, value: unknown)
	if pool.written[property] ~= value then
		pool.instance[property] = value
		pool.written[property] = value
	end
end

const DEFAULT_COLOR_BG = Color3.new(1, 1, 1)
const DEFAULT_COLOR_FG = Color3.new(0, 0, 0)
const DEFAULT_COLOR_SEQUENCE = ColorSequence.new(DEFAULT_COLOR_BG)
const DEFAULT_NUMBER_SEQUENCE = NumberSequence.new(0)
const DEFAULT_IMAGE_STYLE: types.ImageStyle = {}
const ZERO_RECT = Rect.new()

type PrimitiveRenderer = {
	class_name: string,
	init: (pool: PoolInstance) -> (),
	render: (pool: PoolInstance, primitive: types.Primitive) -> (),
}

const PRIMITIVE_RENDERERS: { [types.PrimitiveKind]: PrimitiveRenderer } = {
	solid = {
		class_name = "Frame",
		init = function(pool)
			write(pool, "BorderSizePixel", 0)
		end,
		render = function(pool, primitive)
			write(pool, "BackgroundColor3", primitive.color or DEFAULT_COLOR_BG)
			write(pool, "BackgroundTransparency", primitive.transparency or 0)
		end,
	},

	text = {
		class_name = "TextLabel",
		init = function(pool)
			write(pool, "BorderSizePixel", 0)
			write(pool, "BackgroundTransparency", 1)
		end,
		render = function(pool, primitive)
			const style = primitive.text_style :: types.TextStyle
			write(pool, "Text", primitive.text)
			write(pool, "TextSize", style.size)
			write(pool, "Font", style.font)
			write(pool, "TextColor3", primitive.color or DEFAULT_COLOR_FG)
			write(pool, "TextTransparency", primitive.transparency or 0)
			write(pool, "TextWrapped", style.max_width ~= nil)
			write(pool, "TextXAlignment", style.align_x or Enum.TextXAlignment.Left)
		end,
	},

	image = {
		class_name = "ImageLabel",
		init = function(pool)
			write(pool, "BorderSizePixel", 0)
			write(pool, "BackgroundTransparency", 1)
		end,
		render = function(pool, primitive)
			const style = primitive.image_style :: types.ImageStyle or DEFAULT_IMAGE_STYLE
			write(pool, "Image", primitive.image)
			write(pool, "ImageColor3", primitive.color)
			write(pool, "ImageTransparency", primitive.transparency or 0)
			write(pool, "ScaleType", style.scale_type or Enum.ScaleType.Stretch)
			write(pool, "SliceCenter", style.slice_center or ZERO_RECT)
			write(pool, "SliceScale", style.slice_scale or 1)
			write(pool, "ImageRectOffset", style.rect_offset or Vector2.zero)
			write(pool, "ImageRectSize", style.rect_size or Vector2.zero)
			write(pool, "ResampleMode", style.resample or Enum.ResamplerMode.Default)
		end,
	},

	hit_region = {
		class_name = "Frame",
		init = function(pool)
			write(pool, "BorderSizePixel", 0)
			write(pool, "BackgroundTransparency", 1)
			write(pool, "Active", true)
			write(pool, "Selectable", false)
		end,
		render = function(_, _)
			-- Ink itself does the hit testing, so there's no need to render
			-- anything. Hit regions are then just a transparent Frame to
			-- sink inputs.
		end,
	},

	text_field = {
		class_name = "TextBox",
		init = function(pool)
			write(pool, "BorderSizePixel", 0)
			write(pool, "BackgroundTransparency", 1)
			write(pool, "ClearTextOnFocus", false)
			write(pool, "RichText", false)
			write(pool, "TextXAlignment", Enum.TextXAlignment.Left)

			const box = pool.instance :: TextBox
			pool.text_field_connection = box.FocusLost:Connect(function(enter_pressed)
				if enter_pressed then
					pool.text_field_submitted = true
				end
			end)
		end,
		render = function(pool, primitive)
			const box = pool.instance :: TextBox
			const field = primitive.text_field :: types.TextField
			const style = primitive.text_style :: types.TextStyle
			const options = primitive.text_field_options or {} :: types.TextFieldOptions

			write(pool, "TextSize", style.size)
			write(pool, "Font", style.font)
			write(pool, "TextColor3", primitive.color or DEFAULT_COLOR_FG)
			write(pool, "TextTransparency", primitive.transparency or 0)
			write(pool, "MultiLine", options.multiline == true)
			write(pool, "TextWrapped", options.multiline == true)
			write(pool, "TextXAlignment", style.align_x or Enum.TextXAlignment.Left)
			write(
				pool,
				"TextYAlignment",
				if options.multiline then Enum.TextYAlignment.Top else Enum.TextYAlignment.Center
			)
			write(pool, "TextEditable", options.editable ~= false)

			const text = box.Text
			field.changed = text ~= field.value
			field.value = text
			field.selection_start = box.SelectionStart
			field.selection_cursor = box.CursorPosition
			field.focused = box:IsFocused()
			field.submitted = pool.text_field_submitted == true
			pool.text_field_submitted = false

			if field.pending_value ~= nil then
				box.Text = field.pending_value
				field.value = field.pending_value
				field.pending_value = nil
			end

			if field.pending_selection_cursor ~= nil then
				box.CursorPosition = field.pending_selection_cursor
				field.pending_selection_cursor = nil
			end

			if field.pending_selection_start ~= nil then
				box.SelectionStart = field.pending_selection_start
				field.pending_selection_start = nil
			end

			if field.pending_focus == true then
				box:CaptureFocus()
			elseif field.pending_focus == false then
				box:ReleaseFocus()
			end

			field.pending_focus = nil
		end,
	},
}

type Modifier = {
	class_name: string,
	submodifiers: { string }?,
	render: (pool: PoolInstance, style: any) -> (),
}

const MODIFIERS: { [string]: Modifier } = {
	gradient = {
		class_name = "UIGradient",
		render = function(pool, style: types.GradientStyle)
			write(pool, "Color", style.color or DEFAULT_COLOR_SEQUENCE)
			write(pool, "Offset", Vector2.new(style.offset_x, style.offset_y))
			write(pool, "Rotation", style.rotation or 0)
			write(pool, "Scale", style.scale or 1)
			write(pool, "TileMode", style.tile or Enum.GradientTileMode.Clamp)
			write(pool, "Transparency", style.transparency or DEFAULT_NUMBER_SEQUENCE)
			write(pool, "Type", style.type or Enum.GradientType.Linear)
		end,
	},

	stroke = {
		class_name = "UIStroke",
		submodifiers = { "gradient" },
		render = function(pool, style: types.StrokeStyle)
			write(pool, "Color", style.color or DEFAULT_COLOR_FG)
			write(pool, "ApplyStrokeMode", style.mode or Enum.ApplyStrokeMode.Contextual)
			write(pool, "Thickness", style.thickness or 0)
			write(pool, "Transparency", style.transparency or 0)
		end,
	},

	shadow = {
		class_name = "UIShadow",
		submodifiers = { "gradient" },
		render = function(pool, style: types.ShadowStyle)
			write(pool, "Color", style.color or DEFAULT_COLOR_FG)
			write(pool, "Inset", style.inset or false)
			write(pool, "Mode", style.mode)
			write(pool, "BlurRadius", UDim.new(0, style.radius))
			write(pool, "ShowBehindParent", style.show_behind_parent or false)
			write(pool, "Spread", UDim2.fromOffset(style.spread_x or 0, style.spread_y or 0))
			write(pool, "Transparency", style.transparency or 0)
		end,
	},

	round = {
		class_name = "UICorner",
		render = function(pool, style: types.RoundStyle)
			write(pool, "TopLeftRadius", UDim.new(0, style.top_left))
			write(pool, "TopRightRadius", UDim.new(0, style.top_right))
			write(pool, "BottomLeftRadius", UDim.new(0, style.bottom_left))
			write(pool, "BottomRightRadius", UDim.new(0, style.bottom_right))
		end,
	},
}

const PRIMITIVE_MODIFIERS = {}
for modifier in MODIFIERS do
	table.insert(PRIMITIVE_MODIFIERS, modifier)
end
table.sort(PRIMITIVE_MODIFIERS)

const function apply_modifiers(host: PoolInstance, data: any, fields: { string })
	for _, field in fields do
		const modifier = MODIFIERS[field]
		const style = data[field]
		local child = host.modifiers[field]

		if style then
			if not child then
				child = pool_instance(modifier.class_name)
				host.modifiers[field] = child
			end
			modifier.render(child, style)
			if modifier.submodifiers then
				apply_modifiers(child, style, modifier.submodifiers)
			end
			write(child, "Parent", host.instance)
		elseif child then
			write(child, "Parent", nil)
		end
	end
end

const renderer = {}
renderer.__index = renderer

export type Renderer = setmetatable<{
	root: Instance,
	pools: { [string]: Pool },
	text_fields: { [types.TextField]: PoolInstance },
	seen_text_fields: { [types.TextField]: boolean },
}, typeof(renderer)>

function renderer.new(root: Instance): Renderer
	return setmetatable({
		root = root,
		pools = {},
		text_fields = {},
		seen_text_fields = {},
	}, renderer)
end

const function acquire(self: Renderer, kind: string, class_name: string, init: (PoolInstance) -> ()): PoolInstance
	local pool: Pool = self.pools[kind]
	if not pool then
		pool = { instances = {}, used = 0 }
		self.pools[kind] = pool
	end
	pool.used += 1
	local pooled = pool.instances[pool.used]
	if not pooled then
		pooled = pool_instance(class_name)
		init(pooled)
		pool.instances[pool.used] = pooled
	end
	return pooled
end

const function acquire_text_field(self: Renderer, field: types.TextField): PoolInstance
	self.seen_text_fields[field] = true
	local pooled = self.text_fields[field]
	if not pooled then
		const renderable = PRIMITIVE_RENDERERS.text_field
		pooled = pool_instance(renderable.class_name)
		pooled.instance.Text = field.value
		renderable.init(pooled)
		self.text_fields[field] = pooled
	end
	return pooled
end

const function init_clip(pool: PoolInstance)
	write(pool, "BorderSizePixel", 0)
	write(pool, "BackgroundTransparency", 1)
	write(pool, "ClipsDescendants", true)
end

function renderer.render(self: Renderer, composite: types.Composite)
	for _, pool in self.pools do
		pool.used = 0
	end
	table.clear(self.seen_text_fields)

	local current_clip: Rect? = nil
	local parent: Instance = self.root
	local origin_x, origin_y = 0, 0

	for z, primitive in composite.primitives do
		if not is_equal_rects(primitive.clip, current_clip) then
			current_clip = primitive.clip
			if current_clip then
				const container = acquire(self, "clip", "Frame", init_clip)
				write(container, "Position", UDim2.fromOffset(current_clip.Min.X, current_clip.Min.Y))
				write(container, "Size", UDim2.fromOffset(current_clip.Width, current_clip.Height))
				write(container, "ZIndex", z)
				write(container, "Parent", self.root)
				parent, origin_x, origin_y = container.instance, current_clip.Min.X, current_clip.Min.Y
			else
				parent, origin_x, origin_y = self.root, 0, 0
			end
		end

		local primitive_renderer = PRIMITIVE_RENDERERS[primitive.kind]
		const pooled = if primitive.kind == "text_field"
			then acquire_text_field(self, primitive.text_field :: types.TextField)
			else acquire(self, primitive.kind, primitive_renderer.class_name, primitive_renderer.init)

		primitive_renderer.render(pooled, primitive)

		const b = primitive.bounds
		write(pooled, "Position", UDim2.fromOffset(b.Min.X - origin_x, b.Min.Y - origin_y))
		write(pooled, "Size", UDim2.fromOffset(b.Width, b.Height))
		write(pooled, "Rotation", primitive.rotation or 0)
		write(pooled, "ZIndex", z)

		apply_modifiers(pooled, primitive, PRIMITIVE_MODIFIERS)

		write(pooled, "Parent", parent) -- last
	end

	for _, pool in self.pools do
		for i = pool.used + 1, #pool.instances do
			write(pool.instances[i], "Parent", nil)
		end
	end
	for field, pooled in self.text_fields do
		if not self.seen_text_fields[field] then
			destroy_pool_instance(pooled)
			self.text_fields[field] = nil
		end
	end
end

function renderer.destroy(self: Renderer)
	for _, pool in self.pools do
		for _, pooled in pool.instances do
			destroy_pool_instance(pooled)
		end
	end

	for _, pooled in self.text_fields do
		destroy_pool_instance(pooled)
	end

	table.clear(self.pools)
	table.clear(self.text_fields)
end

return table.freeze(renderer)
