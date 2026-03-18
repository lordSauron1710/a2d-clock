// Port of A2DClockCore/ClockSlot.swift

export interface LogicalPoint {
  x: number;
  y: number;
}

export interface ClockSlot {
  id: number;
  digitIndex: number;
  row: number;
  column: number;
  position: LogicalPoint;
}

const DIGIT_COLUMNS = 2;
const DIGIT_ROWS    = 3;
const STANDARD_GAP  = 0.12;
const CENTER_GAP    = 0.18;

const LOCAL_COORDS = [
  { row: 0, column: 0 }, { row: 0, column: 1 },
  { row: 1, column: 0 }, { row: 1, column: 1 },
  { row: 2, column: 0 }, { row: 2, column: 1 },
];

function xOffset(digitIndex: number): number {
  return digitIndex * (DIGIT_COLUMNS + STANDARD_GAP) + (digitIndex >= 2 ? CENTER_GAP : 0);
}

export const ALL_SLOTS: ClockSlot[] = Array.from({ length: 4 }, (_, digitIndex) => {
  const baseX = xOffset(digitIndex);
  return LOCAL_COORDS.map((coord, localIndex) => ({
    id: digitIndex * 6 + localIndex,
    digitIndex,
    row: coord.row,
    column: coord.column,
    position: { x: baseX + coord.column, y: coord.row },
  }));
}).flat();

const allX = ALL_SLOTS.map((s) => s.position.x);
const allY = ALL_SLOTS.map((s) => s.position.y);

export const LAYOUT_WIDTH:  number = Math.max(...allX) - Math.min(...allX) + 1;
export const LAYOUT_HEIGHT: number = DIGIT_ROWS;
export const LOGICAL_MIN_X: number = Math.min(...allX);
export const LOGICAL_MIN_Y: number = Math.min(...allY);

export const LOGICAL_CENTER: LogicalPoint = {
  x: (Math.min(...allX) + Math.max(...allX)) / 2,
  y: (Math.min(...allY) + Math.max(...allY)) / 2,
};
