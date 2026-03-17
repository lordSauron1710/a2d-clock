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

    func testEngineUsesTwentyFourHourDigits() {
        let date = makeDate(hour: 13, minute: 5, second: 30)
        let engine = ClockClockEngine()

        XCTAssertEqual(engine.digits(for: date, calendar: calendar), [1, 3, 0, 5])
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
        let engine = ClockClockEngine(transitionDuration: 2.4, flourishSplit: 0.34)
        let frame = engine.frame(for: date, calendar: calendar)

        XCTAssertEqual(frame.digits, [1, 0, 1, 1])
        XCTAssertEqual(frame.poses, DigitGlyph.poses(for: [1, 0, 1, 0]))
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
