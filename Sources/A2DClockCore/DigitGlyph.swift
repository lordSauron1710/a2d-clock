import Foundation

public enum DigitGlyph {
    public static func poses(for digit: Int) -> [ClockPose] {
        digits[digit] ?? digits[0]!
    }

    public static func poses(for digits: [Int]) -> [ClockPose] {
        digits.flatMap { poses(for: $0) }
    }

    private static let digits: [Int: [ClockPose]] = [
        0: glyph(6, 3, 9, 6, 0, 6, 0, 6, 0, 3, 9, 0),
        1: glyph(7.5, 7.5, 6, 6, 7.5, 7.5, 0, 6, 7.5, 7.5, 0, 0),
        2: glyph(3, 3, 9, 6, 3, 6, 0, 9, 0, 3, 9, 9),
        3: glyph(3, 3, 6, 6, 3, 3, 0, 6, 3, 3, 0, 0),
        4: glyph(6, 3, 6, 6, 0, 3, 0, 6, 7.5, 7.5, 0, 0),
        5: glyph(6, 3, 9, 9, 0, 3, 9, 6, 3, 3, 0, 9),
        6: glyph(6, 3, 9, 9, 0, 6, 9, 6, 0, 3, 9, 0),
        7: glyph(3, 3, 6, 6, 7.5, 7.5, 0, 6, 7.5, 7.5, 0, 0),
        8: glyph(6, 3, 9, 6, 0, 3, 9, 6, 0, 3, 9, 0),
        9: glyph(6, 3, 9, 6, 0, 3, 0, 6, 3, 3, 0, 0)
    ]

    private static func glyph(
        _ a1: Double, _ a2: Double,
        _ b1: Double, _ b2: Double,
        _ c1: Double, _ c2: Double,
        _ d1: Double, _ d2: Double,
        _ e1: Double, _ e2: Double,
        _ f1: Double, _ f2: Double
    ) -> [ClockPose] {
        [
            .clockUnits(a1, a2),
            .clockUnits(b1, b2),
            .clockUnits(c1, c2),
            .clockUnits(d1, d2),
            .clockUnits(e1, e2),
            .clockUnits(f1, f2)
        ]
    }
}
