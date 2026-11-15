---
title: Scopes
sidebar_position: 5
---

# Scopes

Your UI function runs every frame, so anything that should last between
frames, like an animation or a counter, lives in a **scope**.

Scopes form a tree. `s:key(name)` returns a child scope, creating it the first
time:

```luau
const function ui(s: ink.Scope)
	const a = button(s:key("play"), "Play")
	const b = button(s:key("quit"), "Quit")
	return ink.v_stack({ a, b }, 8)
end
```

The same key on the same parent returns the same scope every frame, so its
state carries over.

## Keys must be requested every frame

A scope that isn't requested during a frame is **purged**: its state is
dropped and its cleanups run. Stop drawing something and its state goes away
by itself.

In loops, key by a stable id, not by position, so state follows the item when
the list changes:

```luau
for _, item in items do
	table.insert(rows, row(s:key(item.id), item))
end
```

## Cleanup

`s:on_cleanup(item)` runs when the scope is purged or destroyed. It accepts
functions, instances, connections, threads and tables with a `destroy` or
`Destroy` method:

```luau
const sound = s:once(function()
	return s:on_cleanup(Instance.new("Sound"))
end)
```

`s:destroy()` purges a scope immediately.

## Time

```luau
s:dt()     -- seconds since last frame
s:time()   -- seconds since the root scope started
s:frame()  -- frame number
```
