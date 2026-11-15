---
title: Styling
sidebar_position: 3
---

# Styling

Styling functions apply to every primitive in a composite.

## Tint

```luau
ink.tint(c, color?, transparency?)
```

`tint` recolours and fades. Transparency stacks on top of what's already
there, so fading a composite that's already half transparent keeps it in
proportion. Strokes and shadows fade too:

```luau
label = ink.tint(label, Color3.new(1, 1, 1))  -- recolor
panel = ink.tint(panel, nil, 0.5)             -- fade everything by half
```

## Round

Corners are given as `top_left, top_right, bottom_left, bottom_right`. The
`ink.corners` helpers return all four:

```luau
ink.round(bg, ink.corners.all(8))
ink.round(bg, ink.corners.top(8)) -- only the top corners
ink.round(bg, 8, 8, 0, 0)
```

## Stroke

```luau
ink.stroke(bg, {
	color = Color3.fromHex("#335FFF"),
	thickness = 2,
	transparency = 0,
	mode = Enum.ApplyStrokeMode.Border,
})
```

A stroke can also take a `gradient`.

## Gradient

```luau
ink.gradient(bg, {
	color = ColorSequence.new(Color3.new(1, 0, 0), Color3.new(0, 0, 1)),
	rotation = 90,
})
```

`GradientStyle` mirrors `UIGradient`: `color`, `transparency`, `rotation`,
`offset_x`, `offset_y`, `scale`, `tile` and `type`.

## Shadow

```luau
ink.shadow(card, {
	mode = Enum.ApplyShadowMode.Border,
	color = Color3.new(0, 0, 0),
	transparency = 0.5,
	radius = 8,
	spread_y = 4,
})
```

## Rotate

```luau
ink.rotate(c, degrees, pivot_x?, pivot_y?)
```

Rotates around the composite's centre, or around a pivot. Bounds stay
unrotated, so layout isn't affected.

## Colours

`ink.color` has colour helpers that work in Oklab, so changes look even to the
eye:

```luau
ink.color.shade(c, 0.05)               -- lighter (negative for darker)
ink.color.saturate(c, -0.1)
ink.color.rotate_hue_color(c, 30)
ink.color.contrast(a, b)               -- WCAG contrast ratio
ink.color.readable(bg)                 -- black or white, whichever reads better on bg
```
