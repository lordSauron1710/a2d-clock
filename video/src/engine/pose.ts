// Port of A2DClockCore/ClockPose.swift

export interface ClockPose {
  hourAngle: number;    // radians
  minuteAngle: number;  // radians
  hourOpacity: number;
  minuteOpacity: number;
}

export function clamp(v: number, lo = 0, hi = 1): number {
  return Math.max(lo, Math.min(hi, v));
}

export function normalize(angle: number): number {
  const turn = Math.PI * 2;
  const rem = angle % turn;
  return rem >= 0 ? rem : rem + turn;
}

export function clockwiseDelta(from: number, to: number): number {
  const turn = Math.PI * 2;
  let delta = normalize(to) - normalize(from);
  if (delta < 0) delta += turn;
  return delta;
}

export function angularDistance(a: number, b: number): number {
  const delta = clockwiseDelta(a, b);
  return Math.min(delta, Math.PI * 2 - delta);
}

export function fromClockUnits(
  hour: number,
  minute: number,
  hourOpacity = 1,
  minuteOpacity = 1
): ClockPose {
  return {
    hourAngle: normalize((hour / 12) * Math.PI * 2),
    minuteAngle: normalize((minute / 12) * Math.PI * 2),
    hourOpacity: clamp(hourOpacity),
    minuteOpacity: clamp(minuteOpacity),
  };
}

export function blank(): ClockPose {
  return fromClockUnits(7.5, 7.5, 0, 0);
}

export function interpolatePose(
  from: ClockPose,
  to: ClockPose,
  t: number
): ClockPose {
  const p = clamp(t);
  return {
    hourAngle: from.hourAngle + clockwiseDelta(from.hourAngle, to.hourAngle) * p,
    minuteAngle:
      from.minuteAngle + clockwiseDelta(from.minuteAngle, to.minuteAngle) * p,
    hourOpacity: from.hourOpacity + (to.hourOpacity - from.hourOpacity) * p,
    minuteOpacity:
      from.minuteOpacity + (to.minuteOpacity - from.minuteOpacity) * p,
  };
}

export function withVisibility(
  pose: ClockPose,
  hourOpacity: number,
  minuteOpacity: number
): ClockPose {
  return { ...pose, hourOpacity: clamp(hourOpacity), minuteOpacity: clamp(minuteOpacity) };
}

// Returns combined opacity when both hands are nearly coincident, else null
export function coincidentOpacity(pose: ClockPose): number | null {
  if (pose.hourOpacity <= 0.001 || pose.minuteOpacity <= 0.001) return null;
  if (angularDistance(pose.hourAngle, pose.minuteAngle) >= 0.02) return null;
  return 1 - (1 - pose.hourOpacity) * (1 - pose.minuteOpacity);
}
