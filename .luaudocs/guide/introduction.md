---
title: Introduction
sidebar_position: 1
---

# Introduction

::: warning

Ink is pre-release and is subject to breaking changes as needed. Documentation
is also a work in progress!

:::

Ink is an immediate-mode UI library for Roblox. Build composites from simple
shapes, lay them out with plain functions, and animate anything, all without
fighting the instance tree.

That's quite a mouthful. Let's elaborate on what Ink is before delving deeper.

## Ink is immediate-mode

Roblox UI is traditionally _retained-mode_. You create instances once, keep them
around, and update them as your state changes. Most of the work is keeping the
instance tree in sync with your game.

Ink is _immediate-mode_. Your UI is a function that describes the whole screen,
and it runs every frame. If something should be on screen, you return it. If it
shouldn't, you don't. There's nothing to create, update or clean up.

This isn't as slow as it sounds. Ink reuses its instances behind the scenes,
only updates what changed, and lets you cache anything expensive. State that
needs to last between frames, like a hover animation or a counter, lives at
named keys instead of inside objects.

## Ink is made of composite shapes

Everything on screen is built from a few primitives: solids, text, images, and
invisible hotspots for input. These primitives can be composed into
**composites** along with set _bounds_.

Ink lets you operate on composites _after creation_. Ink provides an assortment
of API members to transform and construct composites this way. For example, you
can [`pad_all`](/api/pad_all) sides of a composite's bounds.

## Ink is low-level

Ink gives you direct control over shapes and hotspots, down to the pixel. Ink
however doesn't come with ready-made components. Ink can be used to implement
your own components like buttons, scroll views, text boxes. It's usually
only a few lines, and the companion [Inkworks](https://github.com/teamfireworks/inkworks)
library has reference implementations you can learn from or copy.

## Prior Art

Ink is built on the ideas in Daniel P. H. Fox's three-part series,
[I made my perfect UI library](https://fluff.blog/2026/09/13/i-made-my-perfect-ui-library.html),
and on prior art from [Fluid](https://github.com/ffrostfall/fluid),
[Flux](https://github.com/kohltastrophe/flux) and
[Fusion](https://github.com/dphfox/Fusion). Thank you to everyone behind them.
After all, I comes after F.
