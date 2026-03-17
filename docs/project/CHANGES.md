# Changes

## 2026-03-17

- Scaffolded `a2d-clock` as a native macOS Swift package
- Added `A2DClockCore` for digit glyphs, layout metadata, and transition timing
- Built a full-screen screensaver-style prototype with 24 analog mini-dials
- Added repo workflow docs: `README.md`, `AGENTS.md`, `docs/project/ROADMAP.md`
- Added unit tests for the core time/digit engine
- Added a live "Studio" customization panel for appearance, palette, scale, and night glow
- Refactored the renderer to support palette-driven themes and shared transition logic
- Split the renderer into a shared `A2DClockSurface` module used by both the host app and the real saver bundle
- Added 12/24-hour display control and a shared digit-change transition engine for the core clock
- Expanded the dial catalog to 16 selectable families with day/night palette treatments
- Added adaptive redraw pacing and slow whole-board drift to reduce retention risk and idle energy cost
- Added a working `ScreenSaverView` entrypoint plus a configurable `.saver` build pipeline
- Added local-only install tooling that stages the saver into `~/Library/Screen Savers` without a system-wide installer
- Switched the current visual treatment to a white field with black hands and removed stale movement-mode UI
