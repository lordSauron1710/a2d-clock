# Windows Port Plan

## Status
Parked — requires Windows environment to test. Branch: `windows-port`.

## Technology
C# + WPF. Windows-native, closest analogue to Swift + SwiftUI.
Free toolchain (dotnet SDK). No Windows Store account needed.

## How Windows screensavers work
A `.scr` file is a renamed `.exe` that responds to:
| Flag | Purpose |
|---|---|
| `/s` | Start fullscreen |
| `/c:HWND` | Show settings dialog |
| `/p HWND` | Render into Display Settings preview pane |

## Repo structure
```
Windows/
  A2DClockCore/   ← C# port of the engine (no UI deps)
  A2DClockSaver/  ← WPF screensaver app
  A2DClock.sln
```

## Phase 1 — Port engine to C#
Port `A2DClockCore` (pure logic, no platform APIs) to a C# class library:
- `ClockClockEngine` — pose calculation for a given time
- `DigitGlyph` — digit-to-hand-angle mapping
- `ClockPose` / `ClockSlot` — data models
- `ClockHourFormat` — 12/24h enum
- `ClockFrameTransition` — transition interpolation

## Phase 2 — Screensaver shell
WPF app, `Main()` parses args:
- `/s` → fullscreen window + render loop, exit on any input
- `/p HWND` → embed into preview pane via Win32 `SetParent`
- `/c` → settings window

## Phase 3 — Rendering
WPF `DrawingContext` or `Canvas` with `Path` elements.
Same hand geometry math as `ClockFaceView` / `ClockHandGeometry` — just C# + WPF coordinates.

## Phase 4 — Settings
- Persist to `%APPDATA%\A2DClock\settings.json`
- Port 6 dial palettes (colour values only)
- Simple WPF settings window: mode, palette, hour format

## Phase 5 — Packaging + CI
- Inno Setup → `A2DClockSetup.exe`
- GitHub Actions Windows runner on `v*` tags
- Attach `A2DClockSetup.exe` alongside `A2DClock.zip` on the same GitHub Release

## Distribution
No notarization equivalent. SmartScreen shows "More info → Run anyway" on unsigned
executables — less friction than macOS Gatekeeper.

## Prerequisite to resume
Access to a Windows environment for testing:
- UTM (free) + Windows 11 ARM evaluation image (free, 90-day) runs natively on Apple Silicon
- Or any Windows machine / cloud VM
