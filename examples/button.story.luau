const ink = require("../src")

const BUTTON_STYLE: ink.TextStyle = {
	size = 18,
	font = Enum.Font.GothamBold,
}

const CONTROLS = {
	label = "Continue Game",
	color = Color3.fromHex("#18CB40"),
}

return ink.ui_labs_story({
	controls = CONTROLS,
	render = function(properties: ink.StoryProperties<typeof(CONTROLS)>)
		local content = ink.h_stack(
			{
				ink.image(ink.rect_sized(24, 24), "rbxassetid://8517323790"),
				ink.align(ink.text(properties.controls.label, BUTTON_STYLE), ink.rect_sized(0, 24), nil, 0.5),
			},
			8
		)
		content = ink.pad_xy(content, 16, 12)

		local bg = ink.solid(content.bounds)
		bg = ink.round(bg, 8)

		local shadow = ink.solid(content.bounds)
		shadow = ink.round(shadow, 8)

		local hot, spot = ink.hotspot(properties.scope:key("hitbox"), bg.bounds)

		const target_bg = if hot.state == Enum.GuiState.Hover then ink.color.shade(properties.controls.color, 0.05)
			elseif hot.state == Enum.GuiState.Press then ink.color.shade(properties.controls.color, -0.05)
			else properties.controls.color
		const target_fg = ink.color.shade(target_bg, -0.25)

		bg = ink.tint(bg, ink.tween(properties.scope:key("color_bg"), target_bg, 0.2))
		content = ink.tint(content, ink.tween(properties.scope:key("color_fg"), target_fg, 0.2))
		shadow = ink.tint(shadow, ink.tween(properties.scope:key("color_shadow"), target_fg, 0.2))

		local surface = ink.compose({ bg, content })
		local inset = ink.tween(
			properties.scope:key("inset"),
			hot.state == Enum.GuiState.Press and 4 or 8,
			0.1,
			Enum.EasingStyle.Quint
		)
		shadow = ink.translate(shadow, 0, inset)

		const count_scope = properties.scope:key("count")
		local count = count_scope:get(0)
		if hot.clicked then
			count += 1
			print(`{count}x presses`)
		end
		count_scope:set(count)

		local button = ink.compose({ shadow, surface, spot }, shadow.bounds)
		button = ink.align(button, properties.target_bounds, 0.5, 0.5)

		return button
	end,
})
