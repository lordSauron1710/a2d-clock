# a2d-clock

A native macOS clock screensaver project with a downloadable `.saver` product, a local-only install path, and a reusable rendering core for the clock logic.

## What it does

Build a native macOS screen-object that feels calm from a distance and satisfying up close:

- a 24-face analog grid that reads as `HH:MM` time
- 16 selectable dial families with distinct day/night treatments
- a single coordinated transition that animates only when a digit changes
- screensaver behavior rather than app behavior: full screen, no chrome, low-power redraw pacing, and slow burn-in drift
- a rendering core that can be reused inside a real `.saver` bundle

## Repository layout

```text
Sources/
  A2DClockCore/         Pure clock mapping + transition logic
  A2DClock/             Native macOS host app and rendering
  A2DClockSurface/      Shared SwiftUI/AppKit rendering surface
  A2DClockSaver/        ScreenSaver bundle entrypoint
Tests/
  A2DClockCoreTests/    Unit tests for digit mapping and timing
Support/                Bundle metadata templates and install notes
scripts/                Packaging and local-install helpers
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

## Quick Start

The repository ships both a development host app and a real `.saver` packaging path:

- full-screen launch behavior
- 24 analog mini-dials arranged into `HHMM`
- a slide-over studio panel with live customization controls
- switchable appearance modes plus 12/24-hour display control
- 16 dial families with day/night palette pairs
- digit-change animation only when the displayed numerals change
- footprint and night-glow tuning
- adaptive redraw pacing plus slow whole-board drift to reduce retention and battery cost
- reusable clock layout and digit engine in `A2DClockCore`

```bash
swift run A2DClock
```

You can also open the Swift package directly in Xcode and run the `A2DClock` executable target.

## Downloadable Build

The intended release artifact is a `.saver` bundle named `A2DClock.saver`.

```bash
./scripts/build-saver.sh
```

That writes:

- `dist/A2DClock.saver`
- `dist/A2DClock.zip`

Use `dist/A2DClock.zip` as the clean downloadable artifact. The install helper defaults to that archive and installs only into the current user account:

```bash
./scripts/install-saver.sh
```

That expands the signed saver into `~/Library/Screen Savers` and avoids any system-wide install path, third-party installer, or admin-level setup.

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

## Screensaver Path

The final product is the installable `.saver` bundle. The host app remains useful for development, but release packaging should flow through the saver artifact and the local install script above.

See [docs/project/ROADMAP.md](docs/project/ROADMAP.md) for the packaging plan and product milestones.

## Attribution

This project is an original clock screensaver prototype built for this repository.
