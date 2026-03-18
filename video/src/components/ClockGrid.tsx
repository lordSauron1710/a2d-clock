// Port of A2DClockSurface/ClockFaceView + ClockDisplayView + ClockDisplayLayout
// Single SVG for the whole board — one shared glow filter, no cross-document ID collisions.

import React from "react";
import { ClockFrame } from "../engine/engine";
import {
  ALL_SLOTS,
  LAYOUT_WIDTH,
  LAYOUT_HEIGHT,
  LOGICAL_MIN_X,
  LOGICAL_MIN_Y,
} from "../engine/slots";
import { coincidentOpacity } from "../engine/pose";

export interface ClockTheme {
  isNight: boolean;
  /** CSS color for solid hand fill */
  handColor: string;
  /** CSS color for glow blur layer (already includes desired base opacity) */
  glowColor: string;
  /** 0–1 scale applied to glow opacity so it fades in during theme crossfade */
  glowOpacityScale: number;
}

interface Props {
  frame: ClockFrame;
  theme: ClockTheme;
  width: number;
  height: number;
}

// Matches ClockDisplayLayout.scale in Swift
// = resolvedScale(0.28) / maxScale(1.18) where resolved range is 0.86...1.18
const DISPLAY_SCALE = 0.9496 / 1.18;

function handPointStr(
  cx: number,
  cy: number,
  angle: number,
  faceRadius: number
): string {
  const lineWidth = faceRadius * 0.2;
  const handReach = faceRadius * 1.02;         // seamOverlapMultiplier
  const junctionBack = lineWidth * 0.35;       // junctionOverlapMultiplier

  const dx = Math.sin(angle);
  const dy = -Math.cos(angle);

  const sx = cx - dx * junctionBack;
  const sy = cy - dy * junctionBack;
  const ex = cx + dx * handReach;
  const ey = cy + dy * handReach;

  // trailingNormal = (-dy, dx) * lineWidth/2
  const ox = -dy * lineWidth * 0.5;
  const oy =  dx * lineWidth * 0.5;

  return [
    `${sx - ox},${sy - oy}`,
    `${sx + ox},${sy + oy}`,
    `${ex + ox},${ey + oy}`,
    `${ex - ox},${ey - oy}`,
  ].join(" ");
}

export const ClockGrid: React.FC<Props> = ({ frame, theme, width, height }) => {
  const widthLimited  = (width  * 0.99) / LAYOUT_WIDTH;
  const heightLimited = (height * 0.9)  / LAYOUT_HEIGHT;
  const cellSize      = Math.min(widthLimited, heightLimited) * DISPLAY_SCALE;
  const faceRadius    = cellSize * 0.5;

  const contentW = LAYOUT_WIDTH  * cellSize;
  const contentH = LAYOUT_HEIGHT * cellSize;
  const originX  = (width  - contentW) / 2;
  const originY  = (height - contentH) / 2;

  return (
    <svg
      width={width}
      height={height}
      style={{ display: "block", overflow: "visible" }}
    >
      {theme.glowOpacityScale > 0.01 && (
        <defs>
          <filter
            id="hand-glow"
            x="-100%"
            y="-100%"
            width="300%"
            height="300%"
          >
            <feGaussianBlur stdDeviation="4.5" result="blur" />
          </filter>
        </defs>
      )}

      {ALL_SLOTS.map((slot, i) => {
        const pose = frame.poses[i];
        const cx =
          originX +
          (slot.position.x - LOGICAL_MIN_X) * cellSize +
          cellSize / 2;
        const cy =
          originY +
          (slot.position.y - LOGICAL_MIN_Y) * cellSize +
          cellSize / 2;

        const co = coincidentOpacity(pose);
        const isCoincident = co !== null;

        const hourOp   = co ?? pose.hourOpacity;
        const minuteOp = pose.minuteOpacity;

        return (
          <g key={slot.id}>
            {/* ── Glow layer (night mode only) ── */}
            {theme.glowOpacityScale > 0.01 && pose.hourOpacity > 0.001 && (
              <polygon
                points={handPointStr(cx, cy, pose.hourAngle, faceRadius)}
                fill={theme.glowColor}
                opacity={hourOp * theme.glowOpacityScale}
                filter="url(#hand-glow)"
              />
            )}
            {theme.glowOpacityScale > 0.01 &&
              !isCoincident &&
              pose.minuteOpacity > 0.001 && (
                <polygon
                  points={handPointStr(cx, cy, pose.minuteAngle, faceRadius)}
                  fill={theme.glowColor}
                  opacity={minuteOp * theme.glowOpacityScale}
                  filter="url(#hand-glow)"
                />
              )}

            {/* ── Solid hand layer ── */}
            {pose.hourOpacity > 0.001 && (
              <polygon
                points={handPointStr(cx, cy, pose.hourAngle, faceRadius)}
                fill={theme.handColor}
                opacity={hourOp}
              />
            )}
            {!isCoincident && pose.minuteOpacity > 0.001 && (
              <polygon
                points={handPointStr(cx, cy, pose.minuteAngle, faceRadius)}
                fill={theme.handColor}
                opacity={minuteOp}
              />
            )}
          </g>
        );
      })}
    </svg>
  );
};
