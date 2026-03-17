import A2DClockCore
@testable import A2DClockSurface
import XCTest

final class ClockFrameTransitionTests: XCTestCase {
    func testFrameTransitionStartsAtSourceAndEndsAtTarget() {
        let startDate = makeDate(hour: 13, minute: 5, second: 5)
        let sourceEngine = ClockClockEngine(hourFormat: .twentyFour)
        let targetEngine = ClockClockEngine(hourFormat: .twelve)
        let sourceFrame = sourceEngine.frame(for: startDate, calendar: calendar)
        let targetFrame = targetEngine.frame(for: startDate, calendar: calendar)
        let transition = ClockFrameTransition(
            source: sourceFrame,
            target: targetFrame,
            startDate: startDate,
            duration: targetEngine.transitionDuration
        )

        XCTAssertNotNil(transition)
        XCTAssertEqual(
            transition?.frame(at: startDate, engine: targetEngine).poses,
            sourceFrame.poses
        )
        XCTAssertEqual(
            transition?.frame(
                at: startDate.addingTimeInterval(targetEngine.transitionDuration + 0.1),
                engine: targetEngine
            ).poses,
            targetFrame.poses
        )
    }

    func testFrameTransitionMovesUnchangedMinuteDigitsDuringFormatToggle() {
        let startDate = makeDate(hour: 13, minute: 5, second: 5)
        let sourceEngine = ClockClockEngine(hourFormat: .twentyFour)
        let targetEngine = ClockClockEngine(hourFormat: .twelve)
        let sourceFrame = sourceEngine.frame(for: startDate, calendar: calendar)
        let targetFrame = targetEngine.frame(for: startDate, calendar: calendar)
        let transition = ClockFrameTransition(
            source: sourceFrame,
            target: targetFrame,
            startDate: startDate,
            duration: targetEngine.transitionDuration
        )
        let unchangedMinuteSlot = ClockSlot.all.first { $0.digitIndex == 3 }!

        XCTAssertEqual(
            sourceFrame.poses[unchangedMinuteSlot.id],
            targetFrame.poses[unchangedMinuteSlot.id]
        )

        let midFrame = transition?.frame(
            at: startDate.addingTimeInterval(targetEngine.transitionDuration * 0.5),
            engine: targetEngine
        )

        XCTAssertNotNil(midFrame)
        XCTAssertNotEqual(midFrame?.poses, sourceFrame.poses)
        XCTAssertNotEqual(midFrame?.poses, targetFrame.poses)
        XCTAssertNotEqual(
            midFrame?.poses[unchangedMinuteSlot.id],
            sourceFrame.poses[unchangedMinuteSlot.id]
        )
        XCTAssertNotEqual(
            midFrame?.poses[unchangedMinuteSlot.id],
            targetFrame.poses[unchangedMinuteSlot.id]
        )
    }

    private var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/New_York")!
        return calendar
    }

    private func makeDate(hour: Int, minute: Int, second: Int) -> Date {
        calendar.date(
            from: DateComponents(
                calendar: calendar,
                timeZone: calendar.timeZone,
                year: 2026,
                month: 3,
                day: 17,
                hour: hour,
                minute: minute,
                second: second
            )
        )!
    }
}
