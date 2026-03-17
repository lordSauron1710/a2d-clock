import A2DClockCore
import XCTest

final class ClockClockEngineTests: XCTestCase {
    func testEveryDigitMapsToSixClocks() {
        for digit in 0 ... 9 {
            XCTAssertEqual(DigitGlyph.poses(for: digit).count, 6)
        }
    }

    func testDigitTwoMatchesReferenceGlyph() {
        let glyph = DigitGlyph.poses(for: 2)

        XCTAssertEqual(glyph[0], .clockUnits(3, 3))
        XCTAssertEqual(glyph[1], .clockUnits(9, 6))
        XCTAssertEqual(glyph[5], .clockUnits(9, 9))
    }

    func testDigitZeroFormsThreeByTwoOutline() {
        let glyph = DigitGlyph.poses(for: 0)

        XCTAssertEqual(glyph[0], .clockUnits(6, 3))
        XCTAssertEqual(glyph[1], .clockUnits(9, 6))
        XCTAssertEqual(glyph[2], .clockUnits(0, 6))
        XCTAssertEqual(glyph[3], .clockUnits(0, 6))
        XCTAssertEqual(glyph[4], .clockUnits(0, 3))
        XCTAssertEqual(glyph[5], .clockUnits(9, 0))
    }

    func testEngineUsesTwentyFourHourDigits() {
        let date = makeDate(hour: 13, minute: 5, second: 30)
        let engine = ClockClockEngine()

        XCTAssertEqual(engine.digits(for: date, calendar: calendar), [1, 3, 0, 5])
    }

    func testEngineUsesTwentyFourHourDigitsForEveningTime() {
        let date = makeDate(hour: 18, minute: 30, second: 0)
        let engine = ClockClockEngine(hourFormat: .twentyFour)

        XCTAssertEqual(engine.digits(for: date, calendar: calendar), [1, 8, 3, 0])
    }

    func testEngineUsesTwentyFourHourDigitsAtMidnight() {
        let date = makeDate(hour: 0, minute: 0, second: 0)
        let engine = ClockClockEngine(hourFormat: .twentyFour)

        XCTAssertEqual(engine.digits(for: date, calendar: calendar), [0, 0, 0, 0])
    }

    func testEngineUsesTwelveHourDigits() {
        let afternoonDate = makeDate(hour: 13, minute: 5, second: 30)
        let midnightDate = makeDate(hour: 0, minute: 5, second: 30)
        let engine = ClockClockEngine(hourFormat: .twelve)

        XCTAssertEqual(engine.digits(for: afternoonDate, calendar: calendar), [0, 1, 0, 5])
        XCTAssertEqual(engine.digits(for: midnightDate, calendar: calendar), [1, 2, 0, 5])
    }

    func testFrameContainsTwentyFourClockFaces() {
        let date = makeDate(hour: 9, minute: 41, second: 22)
        let engine = ClockClockEngine()
        let frame = engine.frame(for: date, calendar: calendar)

        XCTAssertEqual(frame.poses.count, 24)
        XCTAssertEqual(frame.digits, [0, 9, 4, 1])
    }

    func testMinuteBoundaryStartsFromPreviousMinutePose() {
        let date = makeDate(hour: 10, minute: 11, second: 0)
        let engine = ClockClockEngine()
        let frame = engine.frame(for: date, calendar: calendar)

        XCTAssertEqual(frame.digits, [1, 0, 1, 1])
        XCTAssertEqual(frame.poses, DigitGlyph.poses(for: [1, 0, 1, 0]))
    }

    func testTransitionMovesAwayFromPreviousPoseAfterBoundary() {
        let date = makeDate(hour: 10, minute: 11, second: 0, nanosecond: 900_000_000)
        let engine = ClockClockEngine()
        let frame = engine.frame(for: date, calendar: calendar)

        XCTAssertNotEqual(frame.poses, DigitGlyph.poses(for: [1, 0, 1, 0]))
        XCTAssertNotEqual(frame.poses, DigitGlyph.poses(for: [1, 0, 1, 1]))
    }

    func testTransitionReachesTargetAfterWindow() {
        let engine = ClockClockEngine()
        let date = makeDate(
            hour: 10,
            minute: 11,
            second: Int(engine.transitionDuration.rounded(.up)) + 1
        )
        let frame = engine.frame(for: date, calendar: calendar)

        XCTAssertEqual(frame.poses, DigitGlyph.poses(for: [1, 0, 1, 1]))
    }

    func testTransitionIsDeterministicMidTransition() {
        let date = makeDate(hour: 10, minute: 11, second: 1, nanosecond: 100_000_000)
        let engine = ClockClockEngine()

        XCTAssertEqual(
            engine.frame(for: date, calendar: calendar).poses,
            engine.frame(for: date, calendar: calendar).poses
        )
    }

    func testClockSlotsEnumerateRowMajorWithinEachDigit() {
        let firstDigit = ClockSlot.all.filter { $0.digitIndex == 0 }

        XCTAssertEqual(firstDigit.map(\.row), [0, 0, 1, 1, 2, 2])
        XCTAssertEqual(firstDigit.map(\.column), [0, 1, 0, 1, 0, 1])
    }

    private var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/New_York")!
        return calendar
    }

    private func makeDate(hour: Int, minute: Int, second: Int, nanosecond: Int = 0) -> Date {
        calendar.date(
            from: DateComponents(
                calendar: calendar,
                timeZone: calendar.timeZone,
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
