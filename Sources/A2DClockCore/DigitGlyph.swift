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
            topLeft: (6, 3), topRight: (9, 6),
            middleLeft: (0, 6), middleRight: (0, 6),
            bottomLeft: (0, 3), bottomRight: (9, 0)
        ),
        1: glyph(
            topLeft: (7.5, 7.5), topRight: (6, 6),
            middleLeft: (7.5, 7.5), middleRight: (0, 6),
            bottomLeft: (7.5, 7.5), bottomRight: (0, 0)
        ),
        2: glyph(
            topLeft: (3, 3), topRight: (9, 6),
            middleLeft: (3, 6), middleRight: (0, 9),
            bottomLeft: (0, 3), bottomRight: (9, 9)
        ),
        3: glyph(
            topLeft: (3, 3), topRight: (6, 6),
            middleLeft: (3, 3), middleRight: (0, 6),
            bottomLeft: (3, 3), bottomRight: (0, 0)
        ),
        4: glyph(
            topLeft: (6, 3), topRight: (6, 6),
            middleLeft: (0, 3), middleRight: (0, 6),
            bottomLeft: (7.5, 7.5), bottomRight: (0, 0)
        ),
        5: glyph(
            topLeft: (6, 3), topRight: (9, 9),
            middleLeft: (0, 3), middleRight: (9, 6),
            bottomLeft: (3, 3), bottomRight: (0, 9)
        ),
        6: glyph(
            topLeft: (6, 3), topRight: (9, 9),
            middleLeft: (0, 6), middleRight: (9, 6),
            bottomLeft: (0, 3), bottomRight: (9, 0)
        ),
        7: glyph(
            topLeft: (3, 3), topRight: (6, 6),
            middleLeft: (7.5, 7.5), middleRight: (0, 6),
            bottomLeft: (7.5, 7.5), bottomRight: (0, 0)
        ),
        8: glyph(
            topLeft: (6, 3), topRight: (9, 6),
            middleLeft: (0, 3), middleRight: (9, 6),
            bottomLeft: (0, 3), bottomRight: (9, 0)
        ),
        9: glyph(
            topLeft: (6, 3), topRight: (9, 6),
            middleLeft: (0, 3), middleRight: (0, 6),
            bottomLeft: (3, 3), bottomRight: (0, 0)
        )
    ]

    private static func glyph(
        topLeft: (Double, Double),
        topRight: (Double, Double),
        middleLeft: (Double, Double),
        middleRight: (Double, Double),
        bottomLeft: (Double, Double),
        bottomRight: (Double, Double)
    ) -> [ClockPose] {
        [
            .clockUnits(topLeft.0, topLeft.1),
            .clockUnits(topRight.0, topRight.1),
            .clockUnits(middleLeft.0, middleLeft.1),
            .clockUnits(middleRight.0, middleRight.1),
            .clockUnits(bottomLeft.0, bottomLeft.1),
            .clockUnits(bottomRight.0, bottomRight.1)
        ]
    }
}
