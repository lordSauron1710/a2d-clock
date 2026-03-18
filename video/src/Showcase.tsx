// Showcase composition
// Sequence:
//   0–2s   Static 12:59  (12h, day, Porcelain)
//   2–4s   Transition 12:59 → 01:00  (all 4 digits change — all 24 faces animate)
//   4–5.5s Hold 01:00 (12h, day)
//   5.5–7.5s Theme crossfade day → night Marina
//   7.5–9s  Hold 01:00 (12h, night Marina)
//   9–11s   Transition 01:00 12h → 13:00 24h  (hour digits change)
//  11–13s   Static 13:00 (24h, night, Marina)

import React from "react";
import { AbsoluteFill, useCurrentFrame, useVideoConfig, interpolate } from "remotion";
import { posesForDigits } from "./engine/glyph";
import { clamp } from "./engine/pose";
import { transitionFrame, ClockFrame } from "./engine/engine";
import { ClockGrid, ClockTheme } from "./components/ClockGrid";
import { Backdrop } from "./components/Backdrop";

// ── Clock state frames ────────────────────────────────────────────────────────
//  12:59 in 12h → displayHour(12) = 12, digits [1,2,5,9]
const FRAME_A: ClockFrame = { digits: [1,2,5,9], poses: posesForDigits([1,2,5,9]) };
//  01:00 in 12h → displayHour(1) = 1,  digits [0,1,0,0]
const FRAME_B: ClockFrame = { digits: [0,1,0,0], poses: posesForDigits([0,1,0,0]) };
//  13:00 in 24h → digits [1,3,0,0]
const FRAME_D: ClockFrame = { digits: [1,3,0,0], poses: posesForDigits([1,3,0,0]) };

// ── Colour constants (Swift values → CSS) ────────────────────────────────────
// Marina lume: Color(red: 0.48, green: 0.9, blue: 1.0)
const MARINA_R = 122, MARINA_G = 230, MARINA_B = 255;
const MARINA_LUME = `rgb(${MARINA_R},${MARINA_G},${MARINA_B})`;

// ── Scene timing (seconds) ───────────────────────────────────────────────────
const T_TRANS_AB_START  = 2;
const T_HOLD_B_START    = 4;
const T_THEME_START     = 5.5;
const T_HOLD_C_START    = 7.5;
const T_TRANS_CD_START  = 9;
const T_END             = 13;

export const Showcase: React.FC = () => {
  const frame = useCurrentFrame();
  const { fps, width, height } = useVideoConfig();
  const t = frame / fps;

  // ── Clock hand animation ──────────────────────────────────────────────────
  const transABProgress = clamp((t - T_TRANS_AB_START) / 2.0);
  const transCDProgress = clamp((t - T_TRANS_CD_START) / 2.0);

  let clockFrame: ClockFrame;
  if (t < T_TRANS_CD_START) {
    clockFrame = transitionFrame(FRAME_A, FRAME_B, transABProgress, 0);
  } else {
    clockFrame = transitionFrame(FRAME_B, FRAME_D, transCDProgress, 1);
  }

  // ── Theme crossfade ───────────────────────────────────────────────────────
  // 0 = pure day, 1 = pure night
  const themeProgress = clamp((t - T_THEME_START) / 2.0);

  // Hand colour: black → Marina lume
  const hR = Math.round(interpolate(themeProgress, [0, 1], [0,    MARINA_R]));
  const hG = Math.round(interpolate(themeProgress, [0, 1], [0,    MARINA_G]));
  const hB = Math.round(interpolate(themeProgress, [0, 1], [0,    MARINA_B]));
  const handColor = `rgb(${hR},${hG},${hB})`;

  // Glow: marina lume colour, opacity scale 0→0.76 as night fades in
  const glowOpacityScale = interpolate(themeProgress, [0, 1], [0, 0.76], {
    extrapolateLeft: "clamp",
    extrapolateRight: "clamp",
  });

  const theme: ClockTheme = {
    isNight: themeProgress > 0.01,
    handColor,
    glowColor: MARINA_LUME,
    glowOpacityScale,
  };

  return (
    <AbsoluteFill style={{ overflow: "hidden" }}>
      <Backdrop width={width} height={height} themeProgress={themeProgress} />
      {/* AbsoluteFill ensures the SVG stacks above the backdrop (positioned > static in paint order) */}
      <AbsoluteFill>
        <ClockGrid frame={clockFrame} theme={theme} width={width} height={height} />
      </AbsoluteFill>
    </AbsoluteFill>
  );
};
