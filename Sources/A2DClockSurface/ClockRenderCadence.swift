import A2DClockCore
import Foundation

public enum ClockRenderCadence {
    public static func nextUpdateInterval(
        for date: Date,
        customization: ClockCustomizationStore
    ) -> TimeInterval {
        let engine = ClockClockEngine(hourFormat: customization.hourFormat)
        let components = Calendar.autoupdatingCurrent.dateComponents([.second, .nanosecond], from: date)
        let seconds = Double(components.second ?? 0)
        let nanoseconds = Double(components.nanosecond ?? 0)
        let secondsIntoMinute = seconds + (nanoseconds / 1_000_000_000.0)
        let fractionalSecond = nanoseconds / 1_000_000_000.0
        let activeWindow = engine.transitionDuration + 0.08

        if secondsIntoMinute < activeWindow {
            return 1.0 / 30.0
        }

        let timeUntilNextTransition = max(0.05, (60.0 - secondsIntoMinute) - activeWindow)
        let timeUntilNextSecondBoundary = max(0.05, 1.0 - fractionalSecond)
        return min(1.0, timeUntilNextTransition, timeUntilNextSecondBoundary)
    }
}
