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
        _ = appearanceMode.resolvedColorScheme(systemColorScheme: systemColorScheme)
        _ = lumeColor

        return Self(
            isNight: false,
            backgroundTop: Color.white,
            backgroundBottom: Color.white,
            vignette: Color.clear,
            boardFill: Color.white,
            frameColor: Color.black,
            cellStroke: Color.black.opacity(0.12),
            faceFills: descriptor.dayFaceFills,
            handColor: Color.black,
            handSecondaryColor: Color.black,
            hubColor: Color.black,
            handGlow: Color.clear,
            hourHand: Color.black,
            minuteHand: Color.black,
            centerCap: Color.black,
            shadow: Color.black.opacity(0.14),
            separator: Color.black.opacity(0.72),
            accentOne: descriptor.accentOne,
            accentTwo: descriptor.accentTwo,
            accentThree: descriptor.accentThree,
            lume: Color.black
        )
    }
}
