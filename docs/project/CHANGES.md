# Changes

## 2026-03-17

- Scaffolded `a2d-clock` as a native macOS Swift package
- Added `A2DClockCore` for digit glyphs, layout metadata, and transition timing
- Built a full-screen screensaver-style prototype with 24 analog mini-dials
- Added repo workflow docs: `README.md`, `AGENTS.md`, `docs/project/ROADMAP.md`
- Added unit tests for the core time/digit engine
- Added a live "Studio" customization panel for background, size, and time-format control
- Refactored the renderer to support palette-driven themes and shared transition logic
- Split the renderer into a shared `A2DClockSurface` module used by both the host app and the real saver bundle
- Added 12/24-hour display control and a shared digit-change transition engine for the core clock
- Iterated through broader palette and dial treatments before converging on a simpler final surface
- Added adaptive redraw pacing and slow whole-board drift to reduce retention risk and idle energy cost
- Added a working `ScreenSaverView` entrypoint plus a configurable `.saver` build pipeline
- Added local-only install tooling that stages the saver into `~/Library/Screen Savers` without a system-wide installer
- Switched the current visual treatment to a white field with black hands and removed stale movement-mode UI
- Corrected the clock to use the intended 3x2 glyph topology and tightened idle cadence so second-driven state stays aligned with system time
- Tightened the proportions, sharpened the rendered hands, and improved readability from a distance
- Added a full-board 12/24-hour format transition so unchanged digits also participate in the choreography during a format toggle
- Expanded automated coverage with exhaustive customization round-trips, simplified theme checks, layout checks, and format-transition motion tests
- Replaced placeholder diagonal “blank” cells with true hand visibility control so sparse digits like `1`, `4`, and `7` read more cleanly through both static and transitioning states
- Tuned the end of the hand choreography with a slightly springier settle and thickened the rendered hands for better legibility at distance
- Simplified customization to five full-screen background colors with fixed black hands and changed the Studio footprint control into a true continuous size slider
- Removed the outer frame, per-cell grids, separator dots, soft glow treatment, and center hubs so the clock now reads as frameless bar-only digits on the selected background
- Tightened kerning, thickened the hands, and changed the transition settle to stay clockwise-only while still ending with a subtle springy feel
- Restored auto/day/night mode with the same five palette choices serving as day backgrounds and night lume colors
- Changed the size control to a 0-100 slider while keeping a large-screen visual scale range under the hood
- Rebuilt the hand renderer so each hand stays a solid rectangle through rotation and both bars overlap cleanly at the pivot without a center gap
- Renamed the shared day/night style chooser to "Theme" and removed the size control so the clock now stays at a smaller fixed composition scale
