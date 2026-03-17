import SwiftUI

struct ClockTheme {
    let isNight: Bool
    let backgroundTop: Color
    let backgroundBottom: Color
    let vignette: Color
    let boardFill: Color
    let frameColor: Color
    let cellStroke: Color
    let faceFills: [Color]
    let handColor: Color
    let handSecondaryColor: Color
    let hubColor: Color
    let handGlow: Color
    let hourHand: Color
    let minuteHand: Color
    let centerCap: Color
    let shadow: Color
    let separator: Color
    let accentOne: Color
    let accentTwo: Color
    let accentThree: Color
    let lume: Color

    func faceFill(for digitIndex: Int) -> Color {
        faceFills[digitIndex % faceFills.count]
    }

    static func make(
        appearanceMode: ClockAppearanceMode,
        systemColorScheme: ColorScheme,
        palette: ClockDialPalette,
        lumeColor: ClockLumeColor
    ) -> Self {
        let descriptor = palette.descriptor
        let resolvedColorScheme = appearanceMode.resolvedColorScheme(systemColorScheme: systemColorScheme)

        switch resolvedColorScheme {
        case .dark:
            return Self(
                isNight: true,
                backgroundTop: descriptor.nightBackgroundTop,
                backgroundBottom: descriptor.nightBackgroundBottom,
                vignette: Color.black.opacity(0.45),
                boardFill: Color(red: 0.08, green: 0.09, blue: 0.1),
                frameColor: Color.black,
                cellStroke: Color.white.opacity(0.14),
                faceFills: descriptor.nightFaceFills,
                handColor: Color.white.opacity(0.94),
                handSecondaryColor: lumeColor.color,
                hubColor: Color.white.opacity(0.92),
                handGlow: lumeColor.color.opacity(0.38),
                hourHand: Color.white.opacity(0.94),
                minuteHand: Color.white.opacity(0.94),
                centerCap: Color.white.opacity(0.9),
                shadow: Color.black.opacity(0.48),
                separator: lumeColor.color.opacity(0.92),
                accentOne: descriptor.accentOne,
                accentTwo: descriptor.accentTwo,
                accentThree: descriptor.accentThree,
                lume: lumeColor.color
            )
        default:
            return Self(
                isNight: false,
                backgroundTop: Color(red: 0.83, green: 0.86, blue: 0.9),
                backgroundBottom: Color(red: 0.72, green: 0.76, blue: 0.81),
                vignette: Color.black.opacity(0.16),
                boardFill: Color.white.opacity(0.985),
                frameColor: Color.black.opacity(0.96),
                cellStroke: Color.black.opacity(0.08),
                faceFills: Array(repeating: Color.white.opacity(0.985), count: 4),
                handColor: Color.black.opacity(0.96),
                handSecondaryColor: Color.black.opacity(0.96),
                hubColor: Color.black.opacity(0.9),
                handGlow: Color.clear,
                hourHand: Color.black.opacity(0.96),
                minuteHand: Color.black.opacity(0.96),
                centerCap: Color.black.opacity(0.92),
                shadow: Color.black.opacity(0.2),
                separator: Color.clear,
                accentOne: descriptor.accentOne,
                accentTwo: descriptor.accentTwo,
                accentThree: descriptor.accentThree,
                lume: lumeColor.color
            )
        }
    }
}
