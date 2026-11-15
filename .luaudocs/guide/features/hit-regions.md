---
title: Hit Regions
sidebar_position: 10
---

# Hit Regions

A hit region is an invisible rect that reports what the pointer is doing to it.

```luau
ink.hit_region(s, bounds, options?)
```

It's a composite, so compose it with the rest of your UI, and a state object
at the same time:

```luau
const hit = ink.hit_region(s:key("hit"), bg.bounds)

if hit.clicked then
	print("clicked")
end

return ink.compose({ bg, label, hit })
```

| Field | Meaning |
| --- | --- |
| `state` | `Enum.GuiState.Idle`, `Hover` or `Press` |
| `clicked` | Pressed and released over this region, this frame |
| `drag` | How far the pointer moved this frame while pressed |
| `pointer` | The pointer's position relative to the region's top-left |
| `wheel` | The scroll wheel delta, if `options.wheel` is set |

## Paint order is input order

Hit regions later in the composite are on top, and only the topmost region
under the pointer is hovered. Put a full-size hit region behind a panel to
stop clicks going through it:

```luau
return ink.compose({
	ink.hit_region(s:key("blocker"), panel.bounds),
	panel,
	close_button,
})
```

A pressed region keeps the press while the pointer is held, even if the
pointer leaves it, which makes dragging work.

## Scrolling

Only regions with `wheel = true` receive the scroll wheel. The topmost one
under the pointer gets it:

```luau
const view = ink.hit_region(s:key("view"), bounds, { wheel = true })
const offset = s:key("offset")
offset:set(offset:get(0) - view.wheel * 40)
```

## One frame behind

Input is resolved against the hit regions from **last** frame. This is
invisible in practice, but means a region's state comes from where it was
drawn last frame.
