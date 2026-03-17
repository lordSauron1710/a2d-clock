import Foundation

public enum DigitGlyph {
    public static func poses(for digit: Int) -> [ClockPose] {
        digits[digit] ?? digits[0]!
    }

    public static func poses(for digits: [Int]) -> [ClockPose] {
        digits.flatMap { poses(for: $0) }
    }

    private static let digits: [Int: [ClockPose]] = [
        0: glyph(
            topLeft: pose(6, 3), topRight: pose(9, 6),
            middleLeft: pose(0, 6), middleRight: pose(0, 6),
            bottomLeft: pose(0, 3), bottomRight: pose(9, 0)
        ),
        1: glyph(
            topLeft: .blank(), topRight: pose(6, 6),
            middleLeft: .blank(), middleRight: pose(0, 6),
            bottomLeft: .blank(), bottomRight: pose(0, 0)
        ),
        2: glyph(
            topLeft: pose(3, 3), topRight: pose(9, 6),
            middleLeft: pose(3, 6), middleRight: pose(0, 9),
            bottomLeft: pose(0, 3), bottomRight: pose(9, 9)
        ),
        3: glyph(
            topLeft: pose(3, 3), topRight: pose(6, 6),
            middleLeft: pose(3, 3), middleRight: pose(0, 6),
            bottomLeft: pose(3, 3), bottomRight: pose(0, 0)
        ),
        4: glyph(
            topLeft: pose(6, 3), topRight: pose(6, 6),
            middleLeft: pose(0, 3), middleRight: pose(0, 6),
            bottomLeft: .blank(), bottomRight: pose(0, 0)
        ),
        5: glyph(
            topLeft: pose(6, 3), topRight: pose(9, 9),
            middleLeft: pose(0, 3), middleRight: pose(9, 6),
            bottomLeft: pose(3, 3), bottomRight: pose(0, 9)
        ),
        6: glyph(
            topLeft: pose(6, 3), topRight: pose(9, 9),
            middleLeft: pose(0, 6), middleRight: pose(9, 6),
            bottomLeft: pose(0, 3), bottomRight: pose(9, 0)
        ),
        7: glyph(
            topLeft: pose(3, 3), topRight: pose(6, 6),
            middleLeft: .blank(), middleRight: pose(0, 6),
            bottomLeft: .blank(), bottomRight: pose(0, 0)
        ),
        8: glyph(
            topLeft: pose(6, 3), topRight: pose(9, 6),
            middleLeft: pose(0, 3), middleRight: pose(9, 6),
            bottomLeft: pose(0, 3), bottomRight: pose(9, 0)
        ),
        9: glyph(
            topLeft: pose(6, 3), topRight: pose(9, 6),
            middleLeft: pose(0, 3), middleRight: pose(0, 6),
            bottomLeft: pose(3, 3), bottomRight: pose(0, 0)
        )
    ]

    private static func pose(_ hour: Double, _ minute: Double) -> ClockPose {
        .clockUnits(hour, minute)
    }

    private static func glyph(
        topLeft: ClockPose,
        topRight: ClockPose,
        middleLeft: ClockPose,
        middleRight: ClockPose,
        bottomLeft: ClockPose,
        bottomRight: ClockPose
    ) -> [ClockPose] {
        [
            topLeft,
            topRight,
            middleLeft,
            middleRight,
            bottomLeft,
            bottomRight
        ]
    }
}
