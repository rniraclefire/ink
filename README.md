<h1>
    <img src="./.luaudocs/public/wordmark.png" alt="Ink" height="200" />
    <br/>
    Roblox UI beyond the instance tree
</h1>

<h3><a href="https://teamfireworks.github.io/ink">Documentation →</a></h3>

Ink is an immediate-mode UI library for Roblox. Build composites from simple
shapes, lay them out with plain functions, and animate anything, all without
fighting the instance tree.

<h2>Example Code</h2>

```luau
local function button(s: ink.Scope, label: string, on_click: () -> ())
	local content = ink.pad_xy(ink.text(label, STYLE, WHITE), 16, 8)
	local hot, spot = ink.hotspot(s:key("hit"), content.bounds)

	if hot.clicked then
		on_click()
	end

    local bg_color = if hit.state == Enum.GuiState.Hover then LIGHT else DARK
	local bg = ink.tween(s:key("bg"), bg_color, 0.15)

	return ink.compose({ ink.solid(content.bounds, bg), content, spot })
end

local function ui()
    local menu = ink.v_stack({
        button(scope:key("play"), "Play", play),
        button(scope:key("settings"), "Settings", open_settings),
    }, 8, 0.5)

    return ink.align(menu, viewport, 0.5, 0.5)
end
```