import A2DClockCore
import SwiftUI

public struct ClockSceneView: View {
    @Environment(\.colorScheme) private var colorScheme

    private let date: Date
    private let customization: ClockCustomizationStore

    public init(date: Date, customization: ClockCustomizationStore) {
        self.date = date
        self.customization = customization
    }

    public var body: some View {
        let theme = ClockTheme.make(
            appearanceMode: customization.appearanceMode,
            systemColorScheme: colorScheme,
            palette: customization.dialPalette,
            lumeColor: customization.lumeColor
        )
        let engine = ClockClockEngine(hourFormat: customization.hourFormat)
        let frame = engine.frame(for: date)

        ZStack {
            AmbientBackdropView(theme: theme)
            ClockDisplayView(
                frame: frame,
                theme: theme,
                date: date,
                scaleOption: customization.scaleOption
            )
        }
        .ignoresSafeArea()
    }
}
