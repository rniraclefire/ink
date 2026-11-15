---
title: Introduction
sidebar_position: 1
---

# Introduction

::: warning

Ink is in alpha! While Ink is usable today, expect breaking changes and bugs
as Ink continues development.

:::

Ink is an immediate-mode UI library for Roblox. Build composites from simple
shapes, lay them out with plain functions, and animate anything, without
fighting the instance tree.

That's a lot in one sentence, so let's break it down.

## Ink is immediate-mode

Roblox UI is usually _retained-mode_. Here, you create instances once, keep them
around, and update them as your game changes. Most of the work goes into keeping
that instance tree in sync with your state.

Ink is _immediate-mode_. With Ink, your UI is a function that describes the
whole screen, and it runs every frame. If something should be on screen, you
return it. If it shouldn't, you don't.

This isn't as slow as it sounds. Ink reuses its instances behind the scenes,
only writes properties that actually changed, and lets you cache anything
expensive. A full frame of a typical UI takes a fraction of a millisecond. State
that needs to last between frames, like a hover animation or a counter, lives
at named keys instead of inside objects.

## Ink is made of composites

Everything on screen is built from a few primitives: solids, text, images, hit
regions and text fields. These primitives can be composed into **composites**
along with set _bounds_.

Ink lets you operate on composites _after creation_. Ink provides an assortment
of functions to transform and construct composites this way:

```luau
local label = ink.text("Play", STYLE)
local padded = ink.pad(label, ink.edges.xy(16, 8))
local button = ink.compose({ ink.solid(padded.bounds), padded })
local centered = ink.align(button, viewport, ink.ALIGN_MID, ink.ALIGN_MID)
```

Since nothing belongs to a parent, anything can be measured, overlapped and
moved anywhere.

## Ink is for real game UI

Immediate mode is often associated with debug tools, because that's what most
Roblox immediate-mode libraries have been used for.

Ink encompasses everything else too, like HUDs, plugins, and component
libraries. Ink comes with animation, layout and input as part of the API.

## Ink is low-level

Ink gives you direct control over shapes and hit regions, down to the pixel. Ink
however doesn't come with ready-made components. Ink can be used to implement
your own components like buttons, scroll views, text boxes. They're usually
only a few lines, and the companion
[Inkworks](https://github.com/teamfireworks/inkworks) library has reference
implementations you can learn from or copy.

## Ink is built on prior art

Ink is built on the ideas in Daniel P. H. Fox's three-part series,
[I made my perfect UI library](https://fluff.blog/2026/09/13/i-made-my-perfect-ui-library.html),
and on prior art from [Fluid](https://github.com/ffrostfall/fluid),
[Flux](https://github.com/kohltastrophe/flux) and
[Fusion](https://github.com/dphfox/Fusion). Thank you to everyone behind them.
After all, I comes after F.
