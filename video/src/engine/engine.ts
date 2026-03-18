// Port of A2DClockCore/ClockClockEngine.swift (transition logic only)

import {
  ClockPose,
  clamp,
  interpolatePose,
  withVisibility,
  normalize,
} from "./pose";
import { ALL_SLOTS, LOGICAL_CENTER } from "./slots";

export interface ClockFrame {
  digits: number[];
  poses: ClockPose[];
}

// ── Math helpers ─────────────────────────────────────────────────────────────

function smoothstep(v: number): number {
  const c = clamp(v);
  return c * c * (3 - 2 * c);
}

function springyProgress(v: number): number {
  const c = clamp(v);
  const overshoot = 0.28;
  const scale = overshoot + 1;
  const shifted = c - 1;
  return clamp(
    1 + scale * Math.pow(shifted, 3) + overshoot * Math.pow(shifted, 2)
  );
}

function slotDist(ax: number, ay: number, bx: number, by: number): number {
  return Math.sqrt(Math.pow(bx - ax, 2) + Math.pow(by - ay, 2));
}

function blendedVisibility(from: number, to: number, progress: number): number {
  if (Math.abs(from - to) < 0.0001) return to;
  const p = clamp(progress);
  if (from > to) {
    return from + (to - from) * smoothstep(clamp(p / 0.34));
  }
  return from + (to - from) * smoothstep(clamp((p - 0.24) / 0.56));
}

// ── Flourish pose ─────────────────────────────────────────────────────────────
// Each face fans out toward a direction based on its position relative to centre,
// with a small per-digit directional bias.

function flourishPose(slot: (typeof ALL_SLOTS)[0], minuteKey: number): ClockPose {
  const dx = slot.position.x - LOGICAL_CENTER.x;
  const dy = slot.position.y - LOGICAL_CENTER.y;
  const baseAngle = Math.atan2(dy, dx) + Math.PI / 2;
  const bias = ((minuteKey + slot.digitIndex) % 3 - 1) * 0.05;
  const spread = 0.42 + slot.column * 0.06;
  return {
    hourAngle:    normalize(baseAngle + bias - spread),
    minuteAngle:  normalize(baseAngle + bias + spread),
    hourOpacity:  1,
    minuteOpacity: 1,
  };
}

// ── Per-slot animation ───────────────────────────────────────────────────────

function animatedPose(
  from: ClockPose,
  to: ClockPose,
  slot: (typeof ALL_SLOTS)[0],
  progress: number,   // already outer-smoothstepped
  minuteKey: number
): ClockPose {
  const dist = slotDist(
    LOGICAL_CENTER.x, LOGICAL_CENTER.y,
    slot.position.x,  slot.position.y
  );
  const localDelay = dist * 0.034 + slot.row * 0.02 + slot.column * 0.012;
  const localProgress = smoothstep(clamp((progress - localDelay) / 0.82));
  const flourish = flourishPose(slot, minuteKey);

  let motionPose: ClockPose;
  if (localProgress < 0.44) {
    motionPose = interpolatePose(from, flourish, smoothstep(localProgress / 0.44));
  } else {
    const sp = clamp((localProgress - 0.44) / 0.56);
    motionPose = interpolatePose(flourish, to, springyProgress(sp));
  }

  return withVisibility(
    motionPose,
    blendedVisibility(from.hourOpacity,   to.hourOpacity,   localProgress),
    blendedVisibility(from.minuteOpacity, to.minuteOpacity, localProgress)
  );
}

// ── Public API ───────────────────────────────────────────────────────────────

export function transitionFrame(
  from: ClockFrame,
  to: ClockFrame,
  progress: number,
  transitionKey: number
): ClockFrame {
  const p = clamp(progress);
  if (p === 0) return { digits: to.digits, poses: from.poses };
  if (p === 1) return to;

  const smoothed = smoothstep(p);
  const poses = ALL_SLOTS.map((slot, i) =>
    animatedPose(from.poses[i], to.poses[i], slot, smoothed, transitionKey)
  );
  return { digits: to.digits, poses };
}
