# Roadmap

## Milestone 1 — Native prototype host // EXECUTED

- Create a reusable clock-core module for glyph mapping and time transitions
- Build a macOS full-screen host app that behaves like a screensaver
- Establish a Bauhaus-inspired visual language with procedural drawing
- Add tests around digit mapping and minute-boundary behavior

## Milestone 2 — Real ScreenSaver bundle // IN PROGRESS

- Add a ScreenSaver target that reuses `A2DClockCore`
- Move host-specific setup behind a shared rendering surface
- Package an installable `.saver`
- Add a small configuration surface for theme, 12/24-hour mode, and motion style

## Milestone 3 — Product polish

- Add multiple dial families and day/night palettes
- Add configurable movement modes inspired by quartz and mechanical sweep
- Tune burn-in prevention with longer-term drift and safe repositioning rules
- Benchmark CPU/GPU use on Retina and external displays

## Milestone 4 — Distribution

- Sign and notarize the screensaver build
- Publish a release artifact for direct install
- Add screenshots and a short demo capture to the repo
