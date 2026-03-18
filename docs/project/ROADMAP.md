# Roadmap

## Milestone 1 — Native prototype host // EXECUTED

- Create a reusable clock-core module for glyph mapping and time transitions
- Build a macOS full-screen host app that behaves like a screensaver
- Establish a refined visual language with procedural drawing
- Add tests around digit mapping and minute-boundary behavior

## Milestone 2 — Real ScreenSaver bundle // EXECUTED

- Add a ScreenSaver target that reuses `A2DClockCore` // EXECUTED
- Move host-specific setup behind a shared rendering surface // EXECUTED
- Package an installable `.saver` // EXECUTED
- Add a small configuration surface for background, 12/24-hour mode, and scale // EXECUTED

## Milestone 3 — Product polish // IN PROGRESS

- Explore richer palette and dial treatments before converging on the simplified final surface // EXECUTED
- Tune a single digit-change transition with calm, legible hand choreography // EXECUTED
- Refine format-toggle choreography and hand readability across state changes // EXECUTED
- Add readability-aware hand suppression and spring-tuned settling // EXECUTED
- Simplify the presentation to frameless bar-only digits with scalable sizing // EXECUTED
- Restore day/night mode with shared palette customization and refined rectangular hand rendering // EXECUTED
- Tune burn-in prevention with longer-term drift, safe repositioning rules, and low-power redraw pacing // EXECUTED
- Benchmark CPU/GPU use on Retina and external displays

## Milestone 4 — Distribution

- Sign and notarize the screensaver build
- Publish a release artifact for direct install
- Add screenshots and a short demo capture to the repo
