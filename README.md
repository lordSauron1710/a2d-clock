# a2d-clock

A native macOS clock screensaver prototype where 24 animated analog faces form four digital time digits.

## What it does

Build a native macOS screen-object that feels calm from a distance and satisfying up close:

- a 24-face analog grid that reads as digital time
- dial styling that emphasizes proportion, material feel, and restrained detail
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
docs/project/ROADMAP.md Milestones and packaging path
docs/project/CHANGES.md Lightweight timeline of repo work
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
- [docs/project/ROADMAP.md](docs/project/ROADMAP.md)
- [docs/project/CHANGES.md](docs/project/CHANGES.md)
- [docs/project/README.md](docs/project/README.md)
- [docs/policies/POLICY_INDEX.md](docs/policies/POLICY_INDEX.md)

## Screensaver path

This first milestone is intentionally a prototype host app. The next step is to reuse `A2DClockCore` inside a ScreenSaver target and package it as an installable `.saver`.

See [docs/project/ROADMAP.md](docs/project/ROADMAP.md) for the packaging plan.

## Attribution

This project is an original clock screensaver prototype built for this repository.
