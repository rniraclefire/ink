---
title: Text Fields
sidebar_position: 11
---

# Text Fields

Text fields are editable text, backed by a real `TextBox` so typing, selection
and mobile keyboards work as expected.

```luau
ink.text_field(s, bounds, default_value, style, color?, transparency?, options?)
```

```luau
const field = ink.text_field(s:key("name"), inner_bounds, "", STYLE)

if field.submitted then
	print("Hello,", field.value)
end

return ink.compose({ bg, field })
```

The text field draws its own text. Draw the background, border and placeholder
yourself.

| Field | Meaning |
| --- | --- |
| `value` | The current text |
| `focused` | Whether it has keyboard focus |
| `changed` | The text changed this frame |
| `submitted` | Enter was pressed this frame |
| `state` | `Enum.GuiState.Idle`, `Hover` or `Press` |
| `selection_start`, `selection_cursor` | The selection, as in `TextBox` |

`default_value` is only used the first time. After that, the field keeps what
the user typed.

## Changing a field

Set a `pending_` field and it's applied on the next render:

```luau
if clear_clicked then
	field.pending_value = ""
	field.pending_focus = true
end
```

Available: `pending_value`, `pending_focus`, `pending_selection_start` and
`pending_selection_cursor`.

## Options

```luau
ink.text_field(s, bounds, "", STYLE, nil, nil, { multiline = true, editable = true })
```
