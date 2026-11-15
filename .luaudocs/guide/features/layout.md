---
title: Layout
sidebar_position: 2
---

# Layout

Layout in Ink is plain functions over composites.

::: tip

Everything in Ink are pixels. You will very rarely see `UDim`s with Ink.

:::

## Moving

```luau
ink.translate(c, x, y)                    -- move by a pixel offset
ink.align(c, container, align_x, align_y) -- position inside a rect
```

`align` takes anchors from 0 to 1 for each axis. Ink has constants for the
common ones:

```luau
ink.align(c, screen, ink.ALIGN_MID, ink.ALIGN_END) -- bottom centre
```

Pass `nil` for an axis to leave it alone.

## Stacks

```luau
ink.v_stack(composites, gap?, align?) -- top to bottom
ink.h_stack(composites, gap?, align?) -- left to right
```

`align` positions items across the stack, within the widest (or tallest) item:

```luau
const row = ink.h_stack({ icon, label }, 8, ink.ALIGN_MID) -- vertically centred
```

For custom layouts, `ink.stack_layout` returns the positions without moving
anything, and `ink.place` moves composites to positions:

```luau
const positions = ink.stack_layout("y", items, 8)
for i, p in positions do
	positions[i] = p + Vector2.new((i - 1) * 24, 0) -- stagger
end
const list = ink.place(items, positions)
```

`ink.masonry(composites, columns, column_width, gap)` places each item in the
shortest column.

## Padding and insets

Edges are given as `top, left, bottom, right`. The `ink.edges` helpers return
all four:

```luau
ink.pad(c, ink.edges.all(8))       -- grow bounds by 8 on every side
ink.pad(c, ink.edges.xy(16, 8))    -- 16 left and right, 8 top and bottom
ink.pad(c, ink.edges.left(12))
ink.pad(c, 4, 8, 4, 8)             -- top, left, bottom, right
```

`pad` grows a composite's bounds without moving its contents. To shrink a
rect, use `ink.inset_rect`:

```luau
const inner = ink.inset_rect(panel_bounds, ink.edges.all(12))
```

## Clipping

`ink.clip(c, rect)` hides anything outside `rect`. Primitives completely
outside are dropped.

```luau
const visible = ink.clip(long_list, view_bounds)
```

## Rects

| Function | Returns |
| --- | --- |
| `ink.rect(x, y, width, height)` | A rect from position and size |
| `ink.rect_sized(width, height)` | A rect at the origin |
| `ink.rect_squared(length)` | A square at the origin |
| `ink.inset_rect(rect, top, left, bottom, right)` | A smaller rect |
| `ink.aspect_fit(container, aspect, align_x?, align_y?)` | The largest rect of that aspect ratio inside the container |
| `ink.aspect_cover(container, aspect, align_x?, align_y?)` | The smallest rect of that aspect ratio covering the container |
| `ink.union_rects(a, b)` | A rect containing both |
| `ink.intersect_rects(a, b)` | Their overlap |
| `ink.is_in_rect(rect, point)` | Whether a point is inside |
| `ink.is_equal_rects(a, b)` | Whether two rects are equal |

## Distributing space

`ink.distribute` splits a length between fixed and fractional sizes, like CSS
grid's `fr`:

```luau
const widths = ink.distribute(screen.Width, { 240, { fr = 1 }, { fr = 2 } }, 8)
-- 240 for the sidebar, the rest split 1:2 with 8px gaps
```

## Virtualizing

`ink.visible_range(offset, view_height, item_height, count)` returns the first
and last item visible at a scroll offset, so you only build what's on screen:

```luau
const first, last = ink.visible_range(scroll, view.Height, 32, #items)
for i = first, last do
	-- build row i
end
```
