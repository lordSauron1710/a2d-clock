# a2d-clock

A native macOS clock screensaver. 24 analog mini-dials arranged into `HHMM` — calm from a distance, satisfying up close.

---

![Transition: day 12h → night 24h](docs/screenshots/transition.gif)

---

## What it does

A 24-face analog clock-clock grid reads the current time as `HHMM`. Every digit is composed of a 3×2 block of mini clock faces, each with two hands. The hands always move clockwise — transitions choreograph all 24 faces simultaneously.

**Themes and appearance**

Six dial palettes (Porcelain, Grove, Saffron, Marina, Blossom, Crimson) each provide a day background color and a night lume glow. Three appearance modes — Auto (follows system), Day, Night — switch between them. Day mode drives the background color; Night mode drives the lume color of the hands.

**Studio panel**

A slide-over panel lets you tune everything live: appearance mode, 12/24-hour format, and dial palette. Changes take effect immediately without restarting the screensaver.

**Screen Burn-in Protection**

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

## Install

**Homebrew:**
```sh
brew install --cask --no-quarantine lordSauron1710/tap/a2d-clock
```

**Manual:**
1. Download `A2DClock.zip` from the [latest release](../../releases/latest) and unzip it
2. Drag **A2DClock.app** to your Applications folder
3. Launch **A2DClock** once — it installs the screensaver automatically
4. Open **System Settings → Screen Saver → Other → A2D Clock**

**If macOS blocks the app:**
```sh
xattr -d com.apple.quarantine /Applications/A2DClock.app
```
Or on Sequoia: **System Settings → Privacy & Security → Open Anyway**.

---

## Requirements

- macOS 13 or later
## 💰 Buy Me A Coffee

[![BuyMeACoffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/sandeepvangara)