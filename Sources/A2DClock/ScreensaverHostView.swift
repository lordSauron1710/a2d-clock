import A2DClockCore
import SwiftUI

struct ScreensaverHostView: View {
    @Environment(\.colorScheme) private var colorScheme

    private let engine = ClockClockEngine()

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { context in
            let theme = ClockTheme.forColorScheme(colorScheme)
            let frame = engine.frame(for: context.date)

            ZStack {
                AmbientBackdropView(theme: theme, date: context.date)
                ClockDisplayView(frame: frame, theme: theme, date: context.date)
                ScreensaverWindowReader()
            }
            .ignoresSafeArea()
        }
    }
}
