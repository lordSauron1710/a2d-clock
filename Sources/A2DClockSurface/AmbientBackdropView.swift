import SwiftUI

struct AmbientBackdropView: View {
    let theme: ClockTheme

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                theme.backgroundColor

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
                    center: .center,
                    startRadius: 0,
                    endRadius: max(proxy.size.width, proxy.size.height) * 0.7
                )
            }
            .ignoresSafeArea()
        }
    }
}
