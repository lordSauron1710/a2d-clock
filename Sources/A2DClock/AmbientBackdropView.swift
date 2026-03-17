import SwiftUI

struct AmbientBackdropView: View {
    let theme: ClockTheme
    let date: Date

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                LinearGradient(
                    colors: [theme.backgroundTop, theme.backgroundBottom],
                    startPoint: .top,
                    endPoint: .bottom
                )

                Circle()
                    .fill(theme.vignette)
                    .blur(radius: proxy.size.width * 0.05)
                    .scaleEffect(1.9)
            }
            .ignoresSafeArea()
        }
    }
}
