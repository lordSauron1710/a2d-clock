// Port of A2DClockSurface/AmbientBackdropView
// Two stable layers (day + night) with the night layer fading in via themeProgress.
// Colours match Swift palette values exactly.

import React from "react";

interface Props {
  width: number;
  height: number;
  /** 0 = full day, 1 = full night */
  themeProgress: number;
}

// Porcelain day: Color(red: 0.92, green: 0.90, blue: 0.86)
const DAY_BG = "rgb(235,230,219)";

// Night bg: Color(red: 0.035, green: 0.040, blue: 0.055)
const NIGHT_BG = "rgba(9,10,14,1)";

// Marina ambient tint: nightLume.opacity(0.18)  →  rgba(122,230,255,0.18)
const MARINA_AMBIENT = "rgba(122,230,255,0.18)";

const fill: React.CSSProperties = {
  position: "absolute",
  inset: 0,
  width: "100%",
  height: "100%",
};

export const Backdrop: React.FC<Props> = ({ width, height, themeProgress }) => {
  const maxDim = Math.max(width, height);

  // Radial gradient sizes matching Swift's max(w,h) * factor
  const ambientR  = maxDim * 0.34;
  const vignetteR = maxDim * 0.74;
  const dayVigR   = maxDim * 0.70;

  return (
    <div style={{ ...fill, position: "absolute" }}>
      {/* ── Day backdrop (always underneath) ── */}
      <div style={{ ...fill, background: DAY_BG }} />
      {/* day diagonal sheen */}
      <div
        style={{
          ...fill,
          background:
            "linear-gradient(135deg, rgba(255,255,255,0.08) 0%, transparent 50%, rgba(0,0,0,0.10) 100%)",
        }}
      />
      {/* day edge vignette */}
      <div
        style={{
          ...fill,
          background: `radial-gradient(circle ${dayVigR}px at center, transparent 0%, rgba(0,0,0,0.12) 100%)`,
        }}
      />

      {/* ── Night backdrop (fades in via themeProgress) ── */}
      <div style={{ ...fill, opacity: themeProgress }}>
        <div style={{ ...fill, background: NIGHT_BG }} />
        {/* night diagonal sheen */}
        <div
          style={{
            ...fill,
            background:
              "linear-gradient(135deg, rgba(255,255,255,0.03) 0%, transparent 50%, rgba(0,0,0,0.26) 100%)",
          }}
        />
        {/* ambient tint (Marina lume glow drifting from centre) */}
        <div
          style={{
            ...fill,
            background: `radial-gradient(circle ${ambientR}px at center, ${MARINA_AMBIENT} 0%, transparent 100%)`,
          }}
        />
        {/* outer vignette */}
        <div
          style={{
            ...fill,
            background: `radial-gradient(circle ${vignetteR}px at center, transparent 0%, rgba(0,0,0,0.24) 100%)`,
          }}
        />
      </div>
    </div>
  );
};
