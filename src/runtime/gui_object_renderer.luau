local color = require("../animation/color")
local is_equal_rects = require("../rects/is_equal_rects")
local types = require("../types")

const gui_object_renderer = {}
gui_object_renderer.__index = gui_object_renderer

export type Renderer = setmetatable<{
	pools: { [string]: { instances: { Instance }, used: number } },
	root: Instance,
}, typeof(gui_object_renderer)>

const DEFAULT_TEXT_STYLE: types.TextStyle = { size = 0, font = Enum.Font.Arial }
const DEFAULT_IMAGE_STYLE: types.ImageStyle = {}
const EMPTY_RECT = Rect.new()

function gui_object_renderer.new(root: Instance): Renderer
	return setmetatable({ pools = {}, root = root }, gui_object_renderer)
end

function gui_object_renderer.acquire<T>(self: Renderer, class_name: string, pool_name: string?): T
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
		if instance:IsA("GuiObject") then
			instance.BorderSizePixel = 0
		end
		pool.instances[pool.used] = instance
	end
	return instance :: any
end

function gui_object_renderer.render(self: Renderer, composite: types.Composite)
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

		local instance: GuiObject
		if primitive.text then
			const style = primitive.text_style or DEFAULT_TEXT_STYLE
			const label = self:acquire<<TextLabel>>("TextLabel")
			label.BackgroundTransparency = 1
			label.Text = primitive.text
			label.TextSize = style.size or 0
			label.TextColor3 = primitive.color or color.BLACK
			label.TextTransparency = primitive.transparency or 0
			label.Font = style.font or Enum.Font.Arial
			instance = label
		elseif primitive.image then
			const style = primitive.image_style or DEFAULT_IMAGE_STYLE
			const img = self:acquire<<ImageLabel>>("ImageLabel")
			img.BackgroundTransparency = 1
			img.Image = primitive.image
			img.ImageColor3 = primitive.color or color.WHITE
			img.ImageTransparency = primitive.transparency or 0
			img.ImageRectOffset = style.rect_offset or Vector2.zero
			img.ImageRectSize = style.rect_size or Vector2.zero
			img.ResampleMode = style.resample or Enum.ResamplerMode.Default
			img.ScaleType = style.scale_type or Enum.ScaleType.Stretch
			img.SliceCenter = style.slice_center or EMPTY_RECT
			img.SliceScale = style.slice_scale or 0
			img.TileSize = style.tile_size or UDim2.fromScale(1, 1)
			instance = img
		elseif primitive.hotspot then
			const spot = self:acquire<<Frame>>("Frame", "Hotspot")
			spot.BackgroundTransparency = 1
			spot.Active = true
			instance = spot
		else
			const frame = self:acquire<<Frame>>("Frame")
			frame.BackgroundColor3 = primitive.color or color.WHITE
			frame.BackgroundTransparency = primitive.transparency or 0
			instance = frame
		end

		instance.Visible = true
		instance.Position = UDim2.fromOffset(primitive.bounds.Min.X - origin.X, primitive.bounds.Min.Y - origin.Y)
		instance.Size = UDim2.fromOffset(primitive.bounds.Width, primitive.bounds.Height)
		instance.Rotation = primitive.rotation or 0
		instance.ZIndex = z

		if primitive.round then
			const corner = self:acquire<<UICorner>>("UICorner")
			const r = primitive.round
			const radius = r.tl or r.tr or r.bl or r.br or 0
			corner.CornerRadius = UDim.new(0, radius)
			corner.Parent = instance
		end

		if instance.Parent ~= parent then
			instance.Parent = parent
		end
	end

	for name, pool in self.pools do
		if name == "UICorner" then
			for i = pool.used + 1, #pool.instances do
				pool.instances[i].Parent = nil
			end
		else
			for i = pool.used + 1, #pool.instances do
				const inst = pool.instances[i]
				if inst:IsA("GuiObject") then
					inst.Visible = false
				else
					inst.Parent = nil
				end
			end
		end
	end

	debug.profileend()
end

function gui_object_renderer.destroy(self: Renderer)
	for _, pool in self.pools do
		for _, instance in pool.instances do
			instance:Destroy()
		end
	end
	table.clear(self.pools)
end

return table.freeze(gui_object_renderer)
