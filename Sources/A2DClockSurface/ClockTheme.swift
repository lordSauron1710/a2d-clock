import SwiftUI

struct ClockTheme {
    let isNight: Bool
    let backgroundColor: Color
    let handColor: Color
    let glowColor: Color
    let ambientTint: Color

    static func make(
        appearanceMode: ClockAppearanceMode,
        systemColorScheme: ColorScheme,
        palette: ClockDialPalette
    ) -> Self {
        let isNight = appearanceMode.resolvedColorScheme(systemColorScheme: systemColorScheme) == .dark

        if isNight {
            return Self(
                isNight: true,
                backgroundColor: Color(red: 0.035, green: 0.04, blue: 0.055),
                handColor: palette.nightLume,
                glowColor: palette.nightLume.opacity(0.76),
                ambientTint: palette.nightLume.opacity(0.18)
            )
        }

        return Self(
            isNight: false,
            backgroundColor: palette.dayBackground,
            handColor: .black,
            glowColor: .clear,
            ambientTint: .clear
        )
    }
}
