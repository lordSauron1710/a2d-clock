# a2d-clock

A Bauhaus-inspired macOS clock screensaver prototype built as a "clock-clock": 24 small analog faces choreograph themselves into four digital time digits.

This project combines two reference directions:

- [Bauhaus Clock](https://bauhausclock.com/) for material feel, dial craft, and ambient Mac screensaver presentation
- [Arduino's analog-faces clock post](https://x.com/arduino/status/1367901925086294024) for the grid-based digital choreography made from many miniature clocks

## What it does

Build a native macOS screen-object that feels calm from a distance and satisfying up close:

- a 24-face analog grid that reads as digital time
- dial styling that borrows from premium watch and Bauhaus details
- screensaver behavior rather than app behavior: full screen, no chrome, slow drift, low distraction
- a rendering core that can later be reused inside a real `.saver` bundle

## Repository layout

```text
Sources/
  A2DClockCore/         Pure clock mapping + transition logic
  A2DClock/             Native macOS host app and rendering
Tests/
  A2DClockCoreTests/    Unit tests for digit mapping and timing
docs/
  policies/             Baseline repo policies used across maintained repos
  project/              Project-level notes and direction
  screenshots/          Placeholder for future captures and demo stills
AGENTS.md               Working rules for future agent sessions
ROADMAP.md              Milestones and packaging path
CHANGES.md              Lightweight timeline of repo work
```

## Prerequisites

- macOS 13 or later
- Xcode 26.3 or Apple Swift 6.2+

## Quick start

The repository currently ships a native macOS prototype using SwiftUI + AppKit:

- full-screen launch behavior
- 24 analog mini-dials arranged into `HHMM`
- minute-change choreography with a burst-and-settle transition
- light and dark visual themes
- subtle whole-scene drift to reduce burn-in risk
- reusable clock layout and digit engine in `A2DClockCore`

```bash
swift run A2DClock
```

You can also open the Swift package directly in Xcode and run the `A2DClock` executable target.

## Testing

```bash
swift test
```

## Documentation map

- [AGENTS.md](AGENTS.md)
- [ROADMAP.md](ROADMAP.md)
- [CHANGES.md](CHANGES.md)
- [docs/project/README.md](docs/project/README.md)
- [docs/policies/POLICY_INDEX.md](docs/policies/POLICY_INDEX.md)

## Screensaver path

This first milestone is intentionally a prototype host app. The next step is to reuse `A2DClockCore` inside a ScreenSaver target and package it as an installable `.saver`.

See [ROADMAP.md](ROADMAP.md) for the packaging plan.

## Attribution

This project is an original prototype inspired by external references. It is not affiliated with Bauhaus Clock, Arduino, or Humans since 1982.
