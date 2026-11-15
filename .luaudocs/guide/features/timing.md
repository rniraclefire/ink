---
title: Timing
sidebar_position: 9
---

# Timing

Timing functions track time in a scope.

```luau
ink.timer(s)           -- seconds since the key was first requested
ink.after(s, seconds)  -- true once the duration has passed
ink.every(s, seconds)  -- true once each time another interval passes
```

```luau
-- Hide a toast after 3 seconds
if ink.after(s:key("expire"), 3) then
	remove(toast)
end

-- Blink a cursor
const visible = s:key("blink"):get(true)
if ink.every(s:key("blink_timer"), 0.5) then
	s:key("blink"):set(not visible)
end
```

Changing the duration restarts the timer. Because timers live in scopes, they
reset when their key stops being requested.
