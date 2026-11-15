---
title: Contexts
sidebar_position: 7
---

# Contexts

A context passes a value down the scope tree, so you don't have to thread it
through every function. Themes and units are the usual examples.

```luau
const theme = ink.context({
	bg = Color3.fromHex("#121215"),
	fg = Color3.fromHex("#F7F7F8"),
})
```

Provide a value on a scope, and every scope keyed inside it can read it:

```luau
const function ui(s: ink.Scope)
	theme:provide(s, LIGHT_THEME)
	return panel(s:key("panel"))
end

const function panel(s: ink.Scope)
	const t = theme:get(s)
	return ink.solid(ink.rect_sized(200, 100), t.bg)
end
```

`get` walks up to the closest scope with a value, or returns the default if
none was provided.

::: warning

Provide every frame. A provided value only counts for the frame it was
provided in, the same as keys.

:::

## Reference

```luau
ink.context(default)          -- a new context
context:provide(scope, value) -- returns value
context:get(scope)
context:clear(scope)          -- removes the value from this scope only
context:destroy()
```
