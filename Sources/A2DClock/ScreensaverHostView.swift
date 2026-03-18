import A2DClockSurface
import SwiftUI

struct ScreensaverHostView: View {
    @State private var customization = ClockCustomizationStore.load()
    @State private var currentDate = Date()
    @State private var isStudioPresented = false
    @State private var renderGeneration = 0

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ClockSceneView(date: currentDate, customization: customization)
                .padding(.trailing, isStudioPresented ? StudioPanelLayout.hostReservedWidth : 0)
                .animation(.spring(response: 0.45, dampingFraction: 0.86), value: isStudioPresented)

            if isStudioPresented {
                ClockStudioPanelView(
                    customization: $customization,
                    persist: {
                        $0.persist()
                        renderGeneration += 1
                    },
                    onClose: { isStudioPresented = false }
                )
                .transition(.move(edge: .trailing).combined(with: .opacity))
            } else {
                Button {
                    isStudioPresented = true
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
                .allowsHitTesting(false)
        }
        .ignoresSafeArea()
        .animation(.spring(response: 0.45, dampingFraction: 0.86), value: isStudioPresented)
        .task(id: renderGeneration) {
            await runRenderLoop()
        }
        .onChange(of: customization) { _ in
            renderGeneration += 1
        }
    }

    @MainActor
    private func runRenderLoop() async {
        while !Task.isCancelled {
            let now = Date()
            currentDate = now

            let interval = ClockRenderCadence.nextUpdateInterval(
                for: now,
                customization: customization
            )

            try? await Task.sleep(for: .seconds(interval))
        }
    }
}
