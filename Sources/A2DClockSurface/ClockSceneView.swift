import A2DClockCore
import SwiftUI

public struct ClockSceneView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var frameTransition: ClockFrameTransition?
    @State private var previousHourFormat: ClockHourFormat?
    @State private var transitionSerial = 0

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
            palette: customization.dialPalette
        )
        let isTransitionActive = frameTransition?.isActive(at: date) ?? false

        TimelineView(.animation(minimumInterval: 1.0 / 30.0, paused: !isTransitionActive)) { context in
            let renderDate = isTransitionActive ? context.date : date
            let engine = ClockClockEngine(hourFormat: customization.hourFormat)
            let liveFrame = engine.frame(for: renderDate)
            let resolvedFrame = resolvedFrame(
                liveFrame: liveFrame,
                at: renderDate,
                engine: engine
            )

            ZStack {
                AmbientBackdropView(theme: theme)
                ClockDisplayView(
                    frame: resolvedFrame,
                    theme: theme,
                    date: renderDate,
                    clockScale: ClockCustomizationStore.defaultClockScale
                )
            }
        }
        .ignoresSafeArea()
        .task(id: transitionSerial) {
            guard let frameTransition else {
                return
            }

            try? await Task.sleep(for: .seconds(frameTransition.duration))
            if self.frameTransition == frameTransition {
                self.frameTransition = nil
            }
        }
        .onAppear {
            previousHourFormat = customization.hourFormat
        }
        .onChange(of: customization.hourFormat) { newHourFormat in
            startHourFormatTransition(to: newHourFormat)
        }
    }

    private func resolvedFrame(
        liveFrame: ClockClockFrame,
        at renderDate: Date,
        engine: ClockClockEngine
    ) -> ClockClockFrame {
        guard let frameTransition else {
            return liveFrame
        }

        guard frameTransition.isActive(at: renderDate) else {
            return liveFrame
        }

        return frameTransition.frame(at: renderDate, engine: engine)
    }

    private func startHourFormatTransition(to newHourFormat: ClockHourFormat) {
        guard let previousHourFormat else {
            self.previousHourFormat = newHourFormat
            return
        }

        guard previousHourFormat != newHourFormat else {
            return
        }

        let startDate = Date()
        let sourceEngine = ClockClockEngine(hourFormat: previousHourFormat)
        let targetEngine = ClockClockEngine(hourFormat: newHourFormat)
        let sourceLiveFrame = sourceEngine.frame(for: startDate)
        let sourceFrame = resolvedFrame(
            liveFrame: sourceLiveFrame,
            at: startDate,
            engine: sourceEngine
        )
        let targetFrame = targetEngine.frame(for: startDate)

        frameTransition = ClockFrameTransition(
            source: sourceFrame,
            target: targetFrame,
            startDate: startDate,
            duration: targetEngine.transitionDuration
        )
        self.previousHourFormat = newHourFormat
        transitionSerial += 1
    }
}
