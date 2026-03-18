import SwiftUI

struct AmbientBackdropView: View {
    let theme: ClockTheme
    var driftCenter: UnitPoint = .center

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                theme.backgroundColor

                if theme.isNight {
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.03),
                            Color.clear,
                            Color.black.opacity(0.26)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )

                    RadialGradient(
                        colors: [
                            theme.ambientTint,
                            Color.clear
                        ],
                        center: driftCenter,
                        startRadius: 0,
                        endRadius: max(proxy.size.width, proxy.size.height) * 0.34
                    )

                    RadialGradient(
                        colors: [
                            Color.clear,
                            Color.black.opacity(0.24)
                        ],
                        center: driftCenter,
                        startRadius: 0,
                        endRadius: max(proxy.size.width, proxy.size.height) * 0.74
                    )
                } else {
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.08),
                            Color.clear,
                            Color.black.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )

                    RadialGradient(
                        colors: [
                            Color.clear,
                            Color.black.opacity(0.12)
                        ],
                        center: driftCenter,
                        startRadius: 0,
                        endRadius: max(proxy.size.width, proxy.size.height) * 0.7
                    )
                }
            }
            .ignoresSafeArea()
        }
    }
}
