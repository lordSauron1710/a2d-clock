import A2DClockCore
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

    func testCadenceStaysWithinExpectedBoundsAcrossFormatsAndCheckpoints() {
        let checkpoints: [(second: Int, nanosecond: Int)] = [
            (0, 0),
            (1, 100_000_000),
            (2, 50_000_000),
            (3, 0),
            (29, 500_000_000),
            (58, 750_000_000)
        ]

        for format in ClockHourFormat.allCases {
            var customization = ClockCustomizationStore()
            customization.hourFormat = format

            for checkpoint in checkpoints {
                let date = makeDate(
                    hour: 18,
                    minute: 24,
                    second: checkpoint.second,
                    nanosecond: checkpoint.nanosecond
                )
                let interval = ClockRenderCadence.nextUpdateInterval(
                    for: date,
                    customization: customization
                )

                if Double(checkpoint.second) + (Double(checkpoint.nanosecond) / 1_000_000_000.0) < 2.08 {
                    XCTAssertEqual(interval, 1.0 / 30.0, accuracy: 0.0001)
                } else {
                    XCTAssertGreaterThanOrEqual(interval, 0.05)
                    XCTAssertLessThanOrEqual(interval, 1.0)
                }
            }
        }
    }

    private func makeDate(hour: Int, minute: Int, second: Int, nanosecond: Int = 0) -> Date {
        Calendar(identifier: .gregorian).date(
            from: DateComponents(
                year: 2026,
                month: 3,
                day: 17,
                hour: hour,
                minute: minute,
                second: second,
                nanosecond: nanosecond
            )
        )!
    }
}
