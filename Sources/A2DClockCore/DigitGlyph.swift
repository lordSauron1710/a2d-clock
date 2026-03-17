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
            topLeft: (6, 3), topMiddle: (9, 6), topRight: (0, 6),
            bottomLeft: (0, 6), bottomMiddle: (0, 3), bottomRight: (9, 0)
        ),
        1: glyph(
            topLeft: (7.5, 7.5), topMiddle: (6, 6), topRight: (7.5, 7.5),
            bottomLeft: (0, 6), bottomMiddle: (7.5, 7.5), bottomRight: (0, 0)
        ),
        2: glyph(
            topLeft: (3, 3), topMiddle: (9, 6), topRight: (3, 6),
            bottomLeft: (0, 9), bottomMiddle: (0, 3), bottomRight: (9, 9)
        ),
        3: glyph(
            topLeft: (3, 3), topMiddle: (6, 6), topRight: (3, 3),
            bottomLeft: (0, 6), bottomMiddle: (3, 3), bottomRight: (0, 0)
        ),
        4: glyph(
            topLeft: (6, 3), topMiddle: (6, 6), topRight: (0, 3),
            bottomLeft: (0, 6), bottomMiddle: (7.5, 7.5), bottomRight: (0, 0)
        ),
        5: glyph(
            topLeft: (6, 3), topMiddle: (9, 9), topRight: (0, 3),
            bottomLeft: (9, 6), bottomMiddle: (3, 3), bottomRight: (0, 9)
        ),
        6: glyph(
            topLeft: (6, 3), topMiddle: (9, 9), topRight: (0, 6),
            bottomLeft: (9, 6), bottomMiddle: (0, 3), bottomRight: (9, 0)
        ),
        7: glyph(
            topLeft: (3, 3), topMiddle: (6, 6), topRight: (7.5, 7.5),
            bottomLeft: (0, 6), bottomMiddle: (7.5, 7.5), bottomRight: (0, 0)
        ),
        8: glyph(
            topLeft: (6, 3), topMiddle: (9, 6), topRight: (0, 3),
            bottomLeft: (9, 6), bottomMiddle: (0, 3), bottomRight: (9, 0)
        ),
        9: glyph(
            topLeft: (6, 3), topMiddle: (9, 6), topRight: (0, 3),
            bottomLeft: (0, 6), bottomMiddle: (3, 3), bottomRight: (0, 0)
        )
    ]

    private static func glyph(
        topLeft: (Double, Double),
        topMiddle: (Double, Double),
        topRight: (Double, Double),
        bottomLeft: (Double, Double),
        bottomMiddle: (Double, Double),
        bottomRight: (Double, Double)
    ) -> [ClockPose] {
        [
            .clockUnits(topLeft.0, topLeft.1),
            .clockUnits(topMiddle.0, topMiddle.1),
            .clockUnits(topRight.0, topRight.1),
            .clockUnits(bottomLeft.0, bottomLeft.1),
            .clockUnits(bottomMiddle.0, bottomMiddle.1),
            .clockUnits(bottomRight.0, bottomRight.1)
        ]
    }
}
