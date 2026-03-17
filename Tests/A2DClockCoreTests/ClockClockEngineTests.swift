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

    func testBlankGlyphCellsAreActuallyInvisibleForSparseDigits() {
        let oneGlyph = DigitGlyph.poses(for: 1)
        XCTAssertEqual(oneGlyph[0].visibleOpacity, 0)
        XCTAssertEqual(oneGlyph[2].visibleOpacity, 0)
        XCTAssertEqual(oneGlyph[4].visibleOpacity, 0)

        let fourGlyph = DigitGlyph.poses(for: 4)
        XCTAssertEqual(fourGlyph[4].visibleOpacity, 0)

        let sevenGlyph = DigitGlyph.poses(for: 7)
        XCTAssertEqual(sevenGlyph[2].visibleOpacity, 0)
        XCTAssertEqual(sevenGlyph[4].visibleOpacity, 0)
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

    func testEveryMinuteMapsCorrectlyAcrossBothHourFormats() {
        for format in ClockHourFormat.allCases {
            let engine = ClockClockEngine(hourFormat: format)

            for hour in 0 ..< 24 {
                for minute in 0 ..< 60 {
                    let date = makeDate(hour: hour, minute: minute, second: 30)
                    let displayedHour = format.displayHour(from: hour)

                    XCTAssertEqual(
                        engine.digits(for: date, calendar: calendar),
                        [displayedHour / 10, displayedHour % 10, minute / 10, minute % 10],
                        "Unexpected digits for \(format.rawValue) at \(hour):\(minute)"
                    )
                }
            }
        }
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

    func testTransitionFrameAnimatesUnchangedDigitsDuringHourFormatToggle() {
        let date = makeDate(hour: 13, minute: 5, second: 5)
        let twentyFourHourEngine = ClockClockEngine(hourFormat: .twentyFour)
        let twelveHourEngine = ClockClockEngine(hourFormat: .twelve)
        let sourceFrame = twentyFourHourEngine.frame(for: date, calendar: calendar)
        let targetFrame = twelveHourEngine.frame(for: date, calendar: calendar)
        let unchangedMinuteSlot = ClockSlot.all.first { $0.digitIndex == 2 }!

        XCTAssertEqual(
            sourceFrame.poses[unchangedMinuteSlot.id],
            targetFrame.poses[unchangedMinuteSlot.id]
        )

        let midFrame = twelveHourEngine.transitionFrame(
            from: sourceFrame,
            to: targetFrame,
            progress: 0.5,
            transitionKey: 17
        )

        XCTAssertEqual(midFrame.digits, targetFrame.digits)
        XCTAssertNotEqual(midFrame.poses, sourceFrame.poses)
        XCTAssertNotEqual(midFrame.poses, targetFrame.poses)
        XCTAssertNotEqual(
            midFrame.poses[unchangedMinuteSlot.id],
            sourceFrame.poses[unchangedMinuteSlot.id]
        )
        XCTAssertNotEqual(
            midFrame.poses[unchangedMinuteSlot.id],
            targetFrame.poses[unchangedMinuteSlot.id]
        )
    }

    func testTransitionKeepsPersistentBlankCellsInvisible() {
        let engine = ClockClockEngine()
        let sourceFrame = ClockClockFrame(
            digits: [1, 2, 3, 4],
            poses: DigitGlyph.poses(for: [1, 2, 3, 4])
        )
        let targetFrame = ClockClockFrame(
            digits: [1, 2, 3, 5],
            poses: DigitGlyph.poses(for: [1, 2, 3, 5])
        )

        let midFrame = engine.transitionFrame(
            from: sourceFrame,
            to: targetFrame,
            progress: 0.5,
            transitionKey: 42
        )

        XCTAssertEqual(midFrame.poses[0].visibleOpacity, 0)
        XCTAssertEqual(midFrame.poses[2].visibleOpacity, 0)
        XCTAssertEqual(midFrame.poses[4].visibleOpacity, 0)
    }

    func testTransitionFadesBlankCellsInAndOut() {
        let engine = ClockClockEngine()
        let blankFrame = ClockClockFrame(
            digits: [0, 0, 0, 0],
            poses: Array(repeating: .blank(), count: 24)
        )
        let visibleFrame = ClockClockFrame(
            digits: [8, 8, 8, 8],
            poses: Array(repeating: .clockUnits(0, 6), count: 24)
        )
        let centerSlot = 14

        let fadeInFrame = engine.transitionFrame(
            from: blankFrame,
            to: visibleFrame,
            progress: 0.5,
            transitionKey: 17
        )
        XCTAssertGreaterThan(fadeInFrame.poses[centerSlot].visibleOpacity, 0)
        XCTAssertLessThan(fadeInFrame.poses[centerSlot].visibleOpacity, 1)

        let fadeOutFrame = engine.transitionFrame(
            from: visibleFrame,
            to: blankFrame,
            progress: 0.18,
            transitionKey: 17
        )
        XCTAssertGreaterThan(fadeOutFrame.poses[centerSlot].visibleOpacity, 0)
        XCTAssertLessThan(fadeOutFrame.poses[centerSlot].visibleOpacity, 1)
    }

    func testPoseInterpolationAlwaysMovesClockwise() {
        let source = ClockPose.clockUnits(3, 3)
        let target = ClockPose.clockUnits(1, 1)
        let midPose = source.interpolated(to: target, progress: 0.5)

        XCTAssertEqual(midPose.hourAngle, ClockPose.radians(forClockUnits: 8), accuracy: 0.0001)
        XCTAssertEqual(midPose.minuteAngle, ClockPose.radians(forClockUnits: 8), accuracy: 0.0001)
    }

    func testTransitionProgressNeverMovesBackwardWhileSettling() {
        let engine = ClockClockEngine()
        let sourceFrame = ClockClockFrame(
            digits: [3, 3, 3, 3],
            poses: Array(repeating: .clockUnits(3, 3), count: 24)
        )
        let targetFrame = ClockClockFrame(
            digits: [1, 1, 1, 1],
            poses: Array(repeating: .clockUnits(1, 1), count: 24)
        )

        let slotIndex = 0
        let targetTravel = clockwiseDelta(
            from: sourceFrame.poses[slotIndex].hourAngle,
            to: targetFrame.poses[slotIndex].hourAngle
        )
        var previousTravel = 0.0

        for progress in stride(from: 0.0, through: 1.0, by: 0.1) {
            let frame = engine.transitionFrame(
                from: sourceFrame,
                to: targetFrame,
                progress: progress,
                transitionKey: 7
            )
            let travel = clockwiseDelta(
                from: sourceFrame.poses[slotIndex].hourAngle,
                to: frame.poses[slotIndex].hourAngle
            )

            XCTAssertGreaterThanOrEqual(travel + 0.0001, previousTravel)
            XCTAssertLessThanOrEqual(travel, targetTravel + 0.0001)
            previousTravel = travel
        }
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

    private func clockwiseDelta(from start: Double, to end: Double) -> Double {
        let turn = Double.pi * 2.0
        let normalizedStart = ClockPose.normalize(start)
        let normalizedEnd = ClockPose.normalize(end)
        var delta = normalizedEnd - normalizedStart
        if delta < 0 {
            delta += turn
        }
        return delta
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
