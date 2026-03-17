# AGENTS — a2d-clock

This repository uses a lightweight prompt-driven workflow similar to other repos in this workspace.

## Agent responsibilities

- Read `docs/project/ROADMAP.md` before making significant changes
- Mark roadmap items with `// IN PROGRESS` or `// EXECUTED` once work begins
- Preserve the split between reusable clock logic and the macOS host app
- Keep the project native, local-first, and low-complexity
- Update `docs/project/CHANGES.md` when a meaningful milestone lands

## Build rules

1. Target macOS only
2. Prefer Swift 6.2+ and SwiftUI/AppKit
3. Do not add third-party dependencies without asking first
4. Keep CPU and redraw cost low enough for screensaver-style idle use
5. Favor procedural drawing over external assets
6. Keep the rendering core reusable for a future `.saver` target

## Design rules

- Treat this as an ambient object, not a dashboard
- Motion should feel mechanical, calm, and intentional
- The grid should stay legible from across a room
- Bauhaus influence should show up in proportion, palette, and restraint
- Avoid clutter, settings sprawl, and novelty effects

## File structure

```text
/Sources/A2DClockCore     Clock glyphs, layout data, time mapping, transitions
/Sources/A2DClock         Native app host, full-screen behavior, drawing
/Tests/A2DClockCoreTests  Unit tests for the clock logic
README.md                 Project overview and run instructions
docs/project/ROADMAP.md   Milestones and future packaging work
docs/project/CHANGES.md   Lightweight change timeline
```
