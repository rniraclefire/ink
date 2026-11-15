---
layout: home

hero:
    name: "Ink"
    text: "Immediate-mode UI for Roblox"
    tagline: "Roblox UI beyond instance trees"
    image:
        src: /wordmark.png
        alt: Ink
    actions:
        - theme: brand
          text: Get Started
          link: /guide/getting-started/introduction
        - theme: alt
          text: API Reference
          link: /api/
        - theme: alt
          text: GitHub
          link: https://github.com/teamfireworks/ink

features:
    - title: Your UI is just a table
      details: Describe the whole screen every frame. If it should be there, return it. There are no instance trees to keep in sync.
      link: /guide/getting-started/introduction
      linkText: Why immediate mode
    - title: Composites, not hierarchies
      details: Everything is a flat list of shapes you can measure, pad, tint, clip and move after it's made.
      link: /guide/features/composites
      linkText: Learn composites
    - title: Layout is just functions
      details: Stacks, alignment, padding and fractional sizing are plain functions over composites. No UIListLayout in sight.
      link: /guide/features/layout
      linkText: Learn layout
    - title: Animate anything
      details: Springs and tweens for numbers, colours, vectors, UDims and more, with colours blended in Oklab.
      link: /guide/features/animation
      linkText: Learn animation
    - title: Input built in
      details: Hit regions for hover, press, click, drag and scroll, ordered by what's drawn on top.
      link: /guide/features/hit-regions
      linkText: Learn hit regions
    - title: Blazingly fast
      details: Instances are pooled and only changed properties are written. A typical frame takes a fraction of a millisecond.
      link: /guide/features/mounting
      linkText: Learn mounting
---

## A button in a few lines

```luau
const function button(s: ink.Scope, label: string): (ink.Composite, boolean)
	local content = ink.text(label, STYLE)
	content = ink.pad(content, ink.edges.xy(16, 8))

	const hit = ink.hit_region(s:key("hit"), content.bounds)
	const color = ink.tween(s:key("color"), if hit.state == Enum.GuiState.Hover then HOVER else IDLE, 0.2)

	local bg = ink.solid(content.bounds, color)
	bg = ink.round(bg, ink.corners.all(8))

	return ink.compose({ bg, content, hit }), hit.clicked
end
```

```luau
const play, play_clicked = button(s:key("play"), "Play")
const quit, quit_clicked = button(s:key("quit"), "Quit")

return ink.align(ink.v_stack({ play, quit }, 8), screen, ink.ALIGN_MID, ink.ALIGN_MID)
```
