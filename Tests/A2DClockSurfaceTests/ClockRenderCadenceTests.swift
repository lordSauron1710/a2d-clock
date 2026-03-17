@testable import A2DClockSurface
import XCTest

final class ClockRenderCadenceTests: XCTestCase {
    func testIdleCadenceDoesNotSleepPastNextSecondBoundary() {
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(
            from: DateComponents(
                year: 2026,
                month: 3,
                day: 17,
                hour: 18,
                minute: 24,
                second: 23,
                nanosecond: 250_000_000
            )
        )!

        let interval = ClockRenderCadence.nextUpdateInterval(
            for: date,
            customization: ClockCustomizationStore()
        )

        XCTAssertLessThanOrEqual(interval, 0.75)
    }

    func testActiveTransitionUsesHighRefreshCadence() {
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(
            from: DateComponents(
                year: 2026,
                month: 3,
                day: 17,
                hour: 18,
                minute: 24,
                second: 1,
                nanosecond: 0
            )
        )!

        let interval = ClockRenderCadence.nextUpdateInterval(
            for: date,
            customization: ClockCustomizationStore()
        )

        XCTAssertEqual(interval, 1.0 / 30.0, accuracy: 0.0001)
    }
}
