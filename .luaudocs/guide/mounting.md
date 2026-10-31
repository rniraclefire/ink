---
title: Mounting
sidebar_position: 4
---

# Mounting

```luau
-- Ink is set up with three independent parts, being the scope, the renderer,
-- and the intents.
--
-- Each one can be adapted out for a different environment, such as a storybook
-- plugin like UI Labs, or another platform like Vortex.

const scope = ink.scope.new()

-- The intent listens to an input source (here, UserInputService) and needs
-- to know where your UI is on screen.
--
-- This callback converts a screen position into a position relative to `root`.
const intent = ink.roblox_intent.new(UserInputService, function(position)
	return position - root.AbsolutePosition
end)

const root = Instance.new("ScreenGui")
root.Parent = Players.LocalPlayer.PlayerGui
const renderer = ink.roblox_renderer.new(root)

-- Here, Ink is rendered every `PreRender`.
-- You don't have to use RunService! Feel free to render every ECS phase or on
-- `PreSimulation` like a pyschopath.
const render_loop = RunService.PreRender:Connect(function(dt)
	-- First, advance time. This brings up state set last frame.
	scope:next(dt)

	-- Then, work out what the player did to the hotspots seen last frame.
	ink.update_intent_state(intent.state, intent:take())

    -- Now, compose your UI!
    const composite = render_ui(scope)

	-- When updating your UI, hotspots may have been rearranged.
    -- You'll need to "commit" the updated hotspots to your intents.
	intent:commit(composite)

    -- Now, finally, render it!
    renderer:render_composite(composite)
end)

-- To clean up Ink:
plugin.Unloading:Once(function()
    render_loop:Disconnect()
    intent:destroy()
    renderer:destroy()
end)
```
