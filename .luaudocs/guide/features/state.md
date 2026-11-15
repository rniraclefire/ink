---
title: State
sidebar_position: 6
---

# State

Each scope holds one value. Store more by keying more scopes.

## `get` and `set`

```luau
const count_scope = s:key("count")
local count = count_scope:get(0)
if hit.clicked then
	count = count_scope:set(count + 1)
end
```

`set` is **deferred**: the new value is visible to `get` from the next frame.
This keeps every part of a frame reading the same state. `set` returns the
value you passed, so you can use it straight away in the current frame.

## `once`

`s:once(init)` runs `init` the first time and returns the same value
afterwards. Use it for mutable tables you change in place:

```luau
const history = s:key("history"):once(function()
	return {}
end)
table.insert(history, value)
```

## `expensive`

```luau
ink.expensive(s, compute, ...)
```

Caches a computation, and only recomputes when its arguments change:

```luau
const style = ink.expensive(s:key("style"), function(_, size: number): ink.TextStyle
	return { size = size, font = Enum.Font.BuilderSans }
end, ink.rem(s, 1))
```

## `async`

```luau
ink.async(s, default, compute, ...)
```

Runs `compute` in a separate thread and returns `default` until it finishes.
It reruns when the arguments change. `compute` receives a `become` function to
report progress early:

```luau
const thumbnail = ink.async(s:key("thumb"), PLACEHOLDER, function(become, user_id: number)
	return Players:GetUserThumbnailAsync(user_id, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
end, player.UserId)
```

Errors are logged as warnings, and the last value stays.
