---
title: Mounting
sidebar_position: 4
---

# Mounting

Mounting connects your UI function to the screen. Ink doesn't run anything by
itself. Instead, you decide when each frame happens.

## `ink.mount`

```luau
ink.mount(target, source, render_ui) -> (render, destroy)
```

- `target` is a `GuiObject` that Ink renders into.
- `source` is where input comes from, usually `UserInputService`.
- `render_ui(scope, bounds)` returns your composite. `bounds` is the size of
  `target`.

It returns a `render(dt)` function to call every frame, and `destroy()`.

```luau
const screen = Instance.new("ScreenGui")
screen.Parent = Players.LocalPlayer.PlayerGui

const root = Instance.new("Frame")
root.BackgroundTransparency = 1
root.Size = UDim2.fromScale(1, 1)
root.Parent = screen

const render, destroy = ink.mount(root, UserInputService, function(s, bounds)
	return ink.align(hud(s:key("hud")), bounds, ink.ALIGN_MID, ink.ALIGN_END)
end)

const connection = RunService.PreRender:Connect(render)
```

You don't have to use `PreRender`. Call `render` from your ECS, a fixed step,
or anywhere else.

To clean up, call the `destroy` callback returned by `mount`:

```luau
connection:Disconnect()
destroy()
```

## What a frame does

`mount` is a small wrapper. If you need something different, build the loop
yourself from the same parts:

```luau
const root = ink.scope()
const view = ink.renderer(target)
const input = ink.input_collector(UserInputService, function(point)
	return point - target.AbsolutePosition
end)

RunService.PreRender:Connect(function(dt)
	root:next(dt)               -- advance time, run cleanups
	input:advance()             -- work out what happened to last frame's hit regions
	const composite = render_ui(root, ink.rect_sized(target.AbsoluteSize.X, target.AbsoluteSize.Y))
	input:commit(composite)     -- register this frame's hit regions
	view:render(composite)      -- update instances
end)
```

::: tip

The order matters: input is resolved against last frame's hit regions, then this
frame's are committed after your UI runs.

:::
