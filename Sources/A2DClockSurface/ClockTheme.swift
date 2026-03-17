import SwiftUI

struct ClockTheme {
    let backgroundColor: Color
    let handColor: Color

    static func make(palette: ClockDialPalette) -> Self {
        return Self(
            backgroundColor: palette.previewColor,
            handColor: .black
        )
    }
}
