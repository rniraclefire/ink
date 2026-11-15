---
title: Units
sidebar_position: 12
---

# Units

Ink works in pixels. Units let you design at one size and scale everything
together.

```luau
ink.px(s, n)   -- n design pixels, scaled and rounded
ink.rem(s, n)  -- n times the base size, scaled and rounded
```

Both read the `ink.units` context, which defaults to `{ scale = 1, rem = 16 }`.

```luau
const pad = ink.rem(s, 0.5)    -- 8 at scale 1, 16 at scale 2
const border = ink.px(s, 1)
```

## Scaling with the screen

Provide units at the root of your UI. `ink.viewport_scale` gives a scale from
the screen height relative to the height you designed for:

```luau
ink.mount(root, UserInputService, function(s, bounds)
	ink.units:provide(s, {
		scale = ink.viewport_scale(bounds, 1080, 0.5, 2),
		rem = 16,
	})
	return hud(s:key("hud"), bounds)
end)
```

The last two arguments clamp the scale, so the UI stays readable on phones and
doesn't get huge on large screens.

Results are rounded to whole pixels, so edges stay sharp.
