local color = require("../animation/color")
local is_equal_rects = require("../rects/is_equal_rects")
local types = require("../types")

--- Draws composites as pooled Roblox GuiObject instances.
const gui_object_renderer = {}
gui_object_renderer.__index = gui_object_renderer

export type GuiObjectRenderer = setmetatable<{
	pools: { [string]: { instances: { Instance }, used: number } },
	root: Instance,
}, typeof(gui_object_renderer)>

function gui_object_renderer.new(root: Instance): GuiObjectRenderer
	return setmetatable({ pools = {}, root = root }, gui_object_renderer)
end

function gui_object_renderer.acquire<T>(self: GuiObjectRenderer, class_name: string, pool_name: string?): T
	const key = pool_name or class_name
	local pool = self.pools[key]
	if not pool then
		pool = { instances = {}, used = 0 }
		self.pools[key] = pool
	end
	pool.used += 1
	local instance = pool.instances[pool.used]
	if not instance then
		instance = Instance.new(class_name)
		pool.instances[pool.used] = instance
	end
	return instance
end

function gui_object_renderer.render(self: GuiObjectRenderer, composite: types.Composite)
	debug.profilebegin("Ink Render")

	for _, pool in self.pools do
		pool.used = 0
	end

	local current_clip: Rect? = nil
	local parent: Instance = self.root
	local origin = Vector2.zero

	for z, primitive in composite.primitives do
		if not is_equal_rects(primitive.clip, current_clip) then
			current_clip = primitive.clip
			if current_clip then
				const container = self:acquire<<Frame>>("Frame", "Clip")
				container.BackgroundTransparency = 1
				container.BorderSizePixel = 0
				container.ClipsDescendants = true
				container.Visible = true
				container.Position = UDim2.fromOffset(current_clip.Min.X, current_clip.Min.Y)
				container.Size = UDim2.fromOffset(current_clip.Width, current_clip.Height)
				container.ZIndex = z

				parent, origin = container, current_clip.Min

				if container.Parent ~= self.root then
					container.Parent = self.root
				end
			else
				parent, origin = self.root, Vector2.zero
			end
		end

		local instance
		if primitive.text then
			const style = primitive.text_style or {} :: types.TextStyle
			instance = self:acquire<<TextLabel>>("TextLabel")
			instance.BackgroundTransparency = 1
			instance.Text = primitive.text
			instance.TextSize = style.size or 0
			instance.TextColor3 = primitive.color or color.BLACK
			instance.TextTransparency = primitive.transparency or 0
			instance.Font = style.font or Enum.Font.Arial
		elseif primitive.image then
			const style = primitive.image_style or {} :: types.ImageStyle
			instance = self:acquire<<ImageLabel>>("ImageLabel")
			instance.BackgroundTransparency = 1
			instance.Image = primitive.image
			instance.ImageColor3 = primitive.color or color.WHITE
			instance.ImageTransparency = primitive.transparency or 0
			instance.ImageRectOffset = style.rect_offset or Vector2.zero
			instance.ImageRectSize = style.rect_size or Vector2.one
			instance.ResampleMode = style.resample or Enum.ResamplerMode.Default
			instance.ScaleType = style.scale_type or Enum.ScaleType.Stretch
			instance.SliceCenter = style.slice_center or Rect.new()
			instance.SliceScale = style.slice_scale or 0
		elseif primitive.hotspot then
			instance = self:acquire<<Frame>>("Frame", "Hotspot")
			instance.BackgroundTransparency = 1
			instance.Active = true
		else
			instance = self:acquire<<Frame>>("Frame")
			instance.BackgroundColor3 = primitive.color or color.WHITE
			instance.BackgroundTransparency = primitive.transparency or 0
		end

		instance.BorderSizePixel = 0
		instance.Visible = true
		instance.Position = UDim2.fromOffset(primitive.bounds.Min.X - origin.X, primitive.bounds.Min.Y - origin.Y)
		instance.Size = UDim2.fromOffset(primitive.bounds.Width, primitive.bounds.Height)
		instance.Rotation = primitive.rotation or 0
		instance.ZIndex = z

		if primitive.round then
			const corner = self:acquire("UICorner") :: UICorner
			corner.TopLeftRadius = UDim.new(0, primitive.round.tl)
			corner.TopRightRadius = UDim.new(0, primitive.round.tr)
			corner.BottomLeftRadius = UDim.new(0, primitive.round.bl)
			corner.BottomRightRadius = UDim.new(0, primitive.round.br)
			corner.Parent = instance
		end

		if instance.Parent ~= parent then
			instance.Parent = parent
		end
	end

	for _, pool in self.pools do
		for i = pool.used + 1, #pool.instances do
			const instance = pool.instances[i]
			if instance:IsA("GuiObject") then
				instance.Visible = false
			else
				instance.Parent = nil
			end
		end
	end

	debug.profileend()
end

function gui_object_renderer.destroy(self: GuiObjectRenderer)
	for _, pool in self.pools do
		for _, instance in pool.instances do
			instance:Destroy()
		end
	end
	table.clear(self.pools)
end

return table.freeze(gui_object_renderer)
