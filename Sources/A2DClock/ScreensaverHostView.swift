import A2DClockCore
import SwiftUI

struct ScreensaverHostView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var customization = ClockCustomizationStore.load()

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { context in
            let theme = ClockTheme.make(
                appearanceMode: customization.appearanceMode,
                systemColorScheme: colorScheme,
                palette: customization.dialPalette,
                lumeColor: customization.lumeColor
            )
            let engine = ClockClockEngine(
                transitionDuration: customization.movementStyle.transitionDuration,
                flourishSplit: customization.movementStyle.flourishSplit,
                transitionStyle: customization.movementStyle.transitionStyle
            )
            let frame = engine.frame(for: context.date)

            ZStack(alignment: .topTrailing) {
                AmbientBackdropView(theme: theme, date: context.date)

                ClockDisplayView(
                    frame: frame,
                    theme: theme,
                    date: context.date,
                    scaleOption: customization.scaleOption
                )
                .padding(.trailing, customization.isStudioPresented ? 420 : 0)
                .animation(.spring(response: 0.45, dampingFraction: 0.86), value: customization.isStudioPresented)

                if customization.isStudioPresented {
                    ClockStudioPanelView(
                        customization: $customization,
                        theme: theme,
                        persist: { $0.persist() }
                    )
                        .padding(.top, 28)
                        .padding(.trailing, 28)
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                } else {
                    Button {
                        customization.isStudioPresented = true
                        customization.persist()
                    } label: {
                        Label("Studio", systemImage: "slider.horizontal.3")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundStyle(.primary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        Capsule()
                                            .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 28)
                    .padding(.trailing, 28)
                }

                ScreensaverWindowReader()
            }
            .ignoresSafeArea()
            .animation(.spring(response: 0.45, dampingFraction: 0.86), value: customization.isStudioPresented)
        }
    }
}
