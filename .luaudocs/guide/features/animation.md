---
title: Animation
sidebar_position: 8
---

# Animation

Animation functions take a scope to remember their progress, and a target.
Change the target and they animate towards it.

## Springs

```luau
ink.spring(s, target, speed?, damping?, initial?)
```

Springs keep their momentum when the target changes, so interrupted
animations stay smooth.

```luau
const open = s:key("open"):get(false)
const y = ink.spring(s:key("y"), if open then 0 else 200, 20, 1)
panel = ink.translate(panel, 0, y)
```

- `speed` defaults to 10. Higher is faster.
- `damping` defaults to 1, which settles without overshooting. Below 1
  bounces, above 1 is sluggish.
- `initial` sets where the spring starts on its first frame. Without it, the
  spring starts at the target.

## Tweens

```luau
ink.tween(s, goal, duration, style?, direction?)
```

Tweens run for a fixed duration with easing. When the goal changes, they
restart from wherever they are.

```luau
const color = ink.tween(s:key("color"), if hovered then HOVER else IDLE, 0.2, Enum.EasingStyle.Quart)
```

## Lerp

`ink.lerp(a, b, alpha)` interpolates between two values of the same type, with
no state.

## What can be animated

`number`, `vector`, `Vector2`, `Vector3`, `Color3`, `UDim`, `UDim2`, `CFrame`,
`Rect`, `NumberRange`, `ColorSequenceKeypoint`, `NumberSequenceKeypoint`,
`PhysicalProperties`, `Ray`, `Region3` and `DateTime`.

Colours animate in Oklab, so transitions don't go muddy in the middle.
