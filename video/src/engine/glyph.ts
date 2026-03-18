// Port of A2DClockCore/DigitGlyph.swift
// Each digit maps to 6 ClockPose values:
//   [topLeft, topRight, middleLeft, middleRight, bottomLeft, bottomRight]

import { ClockPose, fromClockUnits, blank } from "./pose";

function p(hour: number, minute: number): ClockPose {
  return fromClockUnits(hour, minute);
}

function glyph(
  tl: ClockPose, tr: ClockPose,
  ml: ClockPose, mr: ClockPose,
  bl: ClockPose, br: ClockPose
): ClockPose[] {
  return [tl, tr, ml, mr, bl, br];
}

const DIGITS: Record<number, ClockPose[]> = {
  0: glyph(p(6, 3), p(9, 6),  p(0, 6), p(0, 6),  p(0, 3), p(9, 0)),
  1: glyph(blank(), p(6, 6),  blank(), p(0, 6),  blank(), p(0, 0)),
  2: glyph(p(3, 3), p(9, 6),  p(3, 6), p(0, 9),  p(0, 3), p(9, 9)),
  3: glyph(p(3, 3), p(6, 6),  p(3, 3), p(0, 6),  p(3, 3), p(0, 0)),
  4: glyph(p(6, 3), p(6, 6),  p(0, 3), p(0, 6),  blank(), p(0, 0)),
  5: glyph(p(6, 3), p(9, 9),  p(0, 3), p(9, 6),  p(3, 3), p(0, 9)),
  6: glyph(p(6, 3), p(9, 9),  p(0, 6), p(9, 6),  p(0, 3), p(9, 0)),
  7: glyph(p(3, 3), p(6, 6),  blank(), p(0, 6),  blank(), p(0, 0)),
  8: glyph(p(6, 3), p(9, 6),  p(0, 3), p(9, 6),  p(0, 3), p(9, 0)),
  9: glyph(p(6, 3), p(9, 6),  p(0, 3), p(0, 6),  p(3, 3), p(0, 0)),
};

export function posesForDigit(digit: number): ClockPose[] {
  return DIGITS[digit] ?? DIGITS[0]!;
}

export function posesForDigits(digits: number[]): ClockPose[] {
  return digits.flatMap(posesForDigit);
}
