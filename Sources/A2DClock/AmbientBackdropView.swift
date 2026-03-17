import SwiftUI

struct AmbientBackdropView: View {
    let theme: ClockTheme
    let date: Date

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let time = date.timeIntervalSinceReferenceDate

            ZStack {
                LinearGradient(
                    colors: [theme.backgroundTop, theme.backgroundBottom],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                Circle()
                    .fill(theme.accentBlue.opacity(0.08))
                    .frame(width: size.width * 0.28, height: size.width * 0.28)
                    .offset(
                        x: (-size.width * 0.25) + (sin(time / 53.0) * 38.0),
                        y: (-size.height * 0.18) + (cos(time / 41.0) * 26.0)
                    )

                RoundedRectangle(cornerRadius: size.width * 0.02, style: .continuous)
                    .fill(theme.accentYellow.opacity(0.08))
                    .frame(width: size.width * 0.18, height: size.height * 0.06)
                    .rotationEffect(.degrees(-18))
                    .offset(
                        x: size.width * 0.24 + (cos(time / 47.0) * 28.0),
                        y: -size.height * 0.22 + (sin(time / 33.0) * 20.0)
                    )

                Rectangle()
                    .fill(theme.accentRed.opacity(0.05))
                    .frame(width: size.width * 0.11, height: size.height * 0.22)
                    .rotationEffect(.degrees(11))
                    .offset(
                        x: -size.width * 0.31 + (sin(time / 61.0) * 24.0),
                        y: size.height * 0.19 + (cos(time / 37.0) * 18.0)
                    )

                Circle()
                    .fill(theme.vignette)
                    .blur(radius: size.width * 0.04)
                    .scaleEffect(1.9)
            }
            .ignoresSafeArea()
        }
    }
}
