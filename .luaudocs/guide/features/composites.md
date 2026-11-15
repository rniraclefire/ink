---
title: Composites
sidebar_position: 1
---

# Composites

Everything in Ink revolves around composites and primitives.
Composites are a collection of primitive elements with some bounding rectangle.

Importantly, primitives are painted first to last, so later primitives draw on
top. You'll `compose` these composites to form UIs.

## Primitives

There are three visual primitives:

```luau
ink.solid(bounds, color?, transparency?)
ink.text(content, style)
ink.image(bounds, content, style?)
```

The other two, [hit regions](./hit-regions) and
[text fields](./text-fields), handle input.

`ink.text` measures itself. It returns a composite exactly as big as the text,
so you can size things around it:

```luau
const STYLE: ink.TextStyle = { size = 18, font = Enum.Font.BuilderSansBold }

local label = ink.text("Play", STYLE)
print(label.bounds.Width)
```

::: tip

Define `TextStyle` tables outside your render function, or cache them with
[`ink.expensive`](./state#expensive), so they aren't created every frame.

:::

## Composites are values

Every Ink function returns a **new** composite rather than changing the one you
passed in. Reassign the variable as you go:

```luau
local label = ink.text("Play", STYLE)
label = ink.pad(label, ink.edges.xy(16, 8))
label = ink.tint(label, Color3.new(1, 1, 1))
```

Composites don't belong to a parent, so anything can be measured, overlapped
and moved anywhere:

```luau
const function button(s: ink.Scope, label: string)
	local content = ink.text(label, STYLE)
	content = ink.pad(content, ink.edges.xy(16, 8))

	local bg = ink.solid(content.bounds, Color3.fromHex("#F2765E"))
	bg = ink.round(bg, ink.corners.all(8))

	const hit = ink.hit_region(s:key("hit"), bg.bounds)

	return ink.compose({ bg, content, hit }, bg.bounds), hit.clicked
end
```

## Composing

`ink.compose` joins composites into one.

```luau
ink.compose({ bg, content })
```

By default, the composed bounds are a union of all composite bounds. You can
provide your own bounds as below:

```luau
ink.compose({ shadow, bg }, bg.bounds)
```

## Mapping primitives

To write your own transform, use `ink.map_primitives`. It clones each primitive
and passes it to your function:

```luau
const function hide(c: ink.Composite): ink.Composite
	return ink.map_primitives(c, function(primitive)
		primitive.transparency = 1
	end)
end
```
