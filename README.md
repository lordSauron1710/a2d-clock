# a2d-clock

A native macOS clock screensaver. 24 analog mini-dials arranged into `HHMM` — calm from a distance, satisfying up close.

---

<!-- Drop screenshots into docs/screenshots/ and uncomment these lines -->
<!-- ![Day mode](docs/screenshots/day.png) -->
<!-- ![Night mode](docs/screenshots/night.png) -->
<!-- ![Studio panel](docs/screenshots/studio.png) -->

---

## What it does

A 24-face analog clock-clock grid reads the current time as `HHMM`. Every digit is composed of a 3×2 block of mini clock faces, each with two hands. The hands always move clockwise — transitions choreograph all 24 faces simultaneously.

**Themes and appearance**

Six dial palettes (Porcelain, Grove, Saffron, Marina, Blossom, Crimson) each provide a day background color and a night lume glow. Three appearance modes — Auto (follows system), Day, Night — switch between them. Day mode drives the background color; Night mode drives the lume color of the hands.

**Studio panel**

A slide-over panel lets you tune everything live: appearance mode, 12/24-hour format, and dial palette. Changes take effect immediately without restarting the screensaver.

**OLED and XDR safe**

Four-layer burn-in protection designed for Liquid Retina XDR and external OLED displays:

- **Lissajous spatial drift** — two incommensurable sinusoidal periods (47 min / 67 min) trace a non-repeating path across available viewport slack. No pixel dwells longer than any other.
- **Micro-wobble** — ±2pt sub-pixel oscillation at a different tempo keeps content boundary pixels shifting continuously.
- **Luminance breathing** — a 53-minute cycle dims the entire scene by up to 15%, reducing cumulative pixel drive time for bright hands and lume glow.
- **Backdrop gradient drift** — ambient radial gradients drift on their own independent path so no screen region receives a constant background brightness contribution.

**Rendering**

- Adaptive redraw: 30 fps during the 2-second minute-transition window, then back to ~1 fps at idle
- Whole-board digit choreography — every face transitions together, never independently
- Clockwise-only hand motion — no hand ever sweeps backwards

## Repository layout

```text
Sources/
  A2DClockCore/         Pure clock mapping and transition logic
  A2DClockSurface/      SwiftUI rendering surface, themes, studio panel, burn-in
  A2DClock/             Native macOS host app
  A2DClockSaver/        ScreenSaver bundle entrypoint
Tests/
  A2DClockCoreTests/    Digit mapping, timing, transition logic
  A2DClockSurfaceTests/ Layout geometry, hand geometry, burn-in, render cadence
Support/                Bundle metadata and install notes
scripts/                Packaging and local-install helpers
docs/
  screenshots/          Product captures and demo stills
  policies/             Baseline repo policies
  project/              Project-level notes
```

## Prerequisites

- macOS 13 or later
- Swift 6.1+

## Run the development app

```bash
swift run A2DClock
```

Or open the package in Xcode and run the `A2DClock` target directly.

## Build and install the screensaver

```bash
./scripts/build-saver.sh
```

Produces `dist/A2DClock.saver` and `dist/A2DClock.zip`. To install into the current user account only (no admin required):

```bash
./scripts/install-saver.sh
```

Expands and installs into `~/Library/Screen Savers`.

## Tests

```bash
swift test
```

## Documentation

- [AGENTS.md](AGENTS.md) — working rules for agent sessions
- [docs/project/README.md](docs/project/README.md) — project intent and direction
- [docs/policies/POLICY_INDEX.md](docs/policies/POLICY_INDEX.md) — repo policies
