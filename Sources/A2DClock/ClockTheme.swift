import SwiftUI

struct ClockTheme {
    let backgroundTop: Color
    let backgroundBottom: Color
    let vignette: Color
    let faceFills: [Color]
    let faceRim: Color
    let faceGloss: Color
    let majorTick: Color
    let minorTick: Color
    let hourHand: Color
    let minuteHand: Color
    let centerCap: Color
    let shadow: Color
    let separator: Color
    let accentRed: Color
    let accentBlue: Color
    let accentYellow: Color

    func faceFill(for digitIndex: Int) -> Color {
        faceFills[digitIndex % faceFills.count]
    }

    static func forColorScheme(_ colorScheme: ColorScheme) -> Self {
        switch colorScheme {
        case .dark:
            return .night
        default:
            return .day
        }
    }

    private static let day = Self(
        backgroundTop: Color(red: 0.93, green: 0.94, blue: 0.92),
        backgroundBottom: Color(red: 0.82, green: 0.84, blue: 0.85),
        vignette: Color.black.opacity(0.1),
        faceFills: [
            Color(red: 0.96, green: 0.94, blue: 0.91),
            Color(red: 0.93, green: 0.94, blue: 0.95),
            Color(red: 0.95, green: 0.93, blue: 0.89),
            Color(red: 0.91, green: 0.93, blue: 0.93)
        ],
        faceRim: Color(red: 0.34, green: 0.36, blue: 0.38).opacity(0.9),
        faceGloss: Color.white.opacity(0.28),
        majorTick: Color(red: 0.21, green: 0.23, blue: 0.25).opacity(0.92),
        minorTick: Color(red: 0.21, green: 0.23, blue: 0.25).opacity(0.28),
        hourHand: Color(red: 0.12, green: 0.13, blue: 0.14),
        minuteHand: Color(red: 0.18, green: 0.19, blue: 0.2),
        centerCap: Color(red: 0.83, green: 0.21, blue: 0.17),
        shadow: Color.black.opacity(0.22),
        separator: Color(red: 0.83, green: 0.21, blue: 0.17),
        accentRed: Color(red: 0.86, green: 0.27, blue: 0.2),
        accentBlue: Color(red: 0.16, green: 0.33, blue: 0.72),
        accentYellow: Color(red: 0.91, green: 0.75, blue: 0.19)
    )

    private static let night = Self(
        backgroundTop: Color(red: 0.08, green: 0.09, blue: 0.11),
        backgroundBottom: Color(red: 0.02, green: 0.03, blue: 0.04),
        vignette: Color.black.opacity(0.42),
        faceFills: [
            Color(red: 0.15, green: 0.17, blue: 0.2),
            Color(red: 0.13, green: 0.16, blue: 0.19),
            Color(red: 0.16, green: 0.15, blue: 0.18),
            Color(red: 0.12, green: 0.14, blue: 0.16)
        ],
        faceRim: Color.white.opacity(0.18),
        faceGloss: Color.white.opacity(0.08),
        majorTick: Color.white.opacity(0.78),
        minorTick: Color.white.opacity(0.18),
        hourHand: Color(red: 0.95, green: 0.96, blue: 0.97),
        minuteHand: Color(red: 0.9, green: 0.91, blue: 0.93),
        centerCap: Color(red: 0.97, green: 0.52, blue: 0.34),
        shadow: Color.black.opacity(0.44),
        separator: Color(red: 0.97, green: 0.71, blue: 0.28),
        accentRed: Color(red: 0.86, green: 0.29, blue: 0.24),
        accentBlue: Color(red: 0.24, green: 0.49, blue: 0.92),
        accentYellow: Color(red: 0.93, green: 0.77, blue: 0.22)
    )
}
