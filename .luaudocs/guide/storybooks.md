---
title: Storybooks
sidebar_position: 99
---

# Storybooks

Ink supports several storybook plugins on Roblox that allow you to preview and
hot-reload your UI components.

## UI Labs

Construct your story with `ink.ui_labs_story`:

```luau
return ink.ui_labs_story({
	controls = {
		label = "Press Me"
	},
	render = function(properties)
		local btn = button(properties.scope:key("btn"), properties.controls.label)
		btn = ink.align(btn, properties.target_bounds, 0.5, 0.5)
		return btn
	end
})
```

::: warning

Luau incorrectly throws a type error when `:key`-ing the story's scope. You can
work around this by defining controls outside the story, and then annotating
`properties` with the `ink.StoryProperties` type:

```luau
const CONTROLS = {
	label = "Press Me"
}

return ink.ui_labs_story({
	controls = CONTROLS,
	render = function(properties: ink.StoryProperties<typeof(CONTROLS)>)
		local btn = button(properties.scope:key("btn"), properties.controls.label)
		btn = ink.align(btn, properties.target_bounds, 0.5, 0.5)
		return btn
	end
})
```

:::

## Flipbook

::: note

Coming before 0.1.0

:::
