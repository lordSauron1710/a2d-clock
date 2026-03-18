import A2DClockCore
@testable import A2DClockSurface
import XCTest

final class ClockHandGeometryTests: XCTestCase {
    func testOrthogonalHandsUseComplementaryCornerPlacements() {
        let placements = ClockHandGeometry.placements(
            hourAngle: ClockPose.radians(forClockUnits: 9),
            minuteAngle: ClockPose.radians(forClockUnits: 6),
            hourVisible: true,
            minuteVisible: true
        )

        XCTAssertEqual(placements.hour, ClockHandPlacement.trailing)
        XCTAssertEqual(placements.minute, ClockHandPlacement.leading)
    }

    func testReversedOrthogonalHandsFlipCornerPlacements() {
        let placements = ClockHandGeometry.placements(
            hourAngle: ClockPose.radians(forClockUnits: 6),
            minuteAngle: ClockPose.radians(forClockUnits: 9),
            hourVisible: true,
            minuteVisible: true
        )

        XCTAssertEqual(placements.hour, ClockHandPlacement.leading)
        XCTAssertEqual(placements.minute, ClockHandPlacement.trailing)
    }

    func testStraightHandsStayCentered() {
        let placements = ClockHandGeometry.placements(
            hourAngle: ClockPose.radians(forClockUnits: 0),
            minuteAngle: ClockPose.radians(forClockUnits: 6),
            hourVisible: true,
            minuteVisible: true
        )

        XCTAssertEqual(placements.hour, ClockHandPlacement.centered)
        XCTAssertEqual(placements.minute, ClockHandPlacement.centered)
    }

    func testSingleVisibleHandStaysCentered() {
        let placements = ClockHandGeometry.placements(
            hourAngle: ClockPose.radians(forClockUnits: 3),
            minuteAngle: ClockPose.radians(forClockUnits: 9),
            hourVisible: true,
            minuteVisible: false
        )

        XCTAssertEqual(placements.hour, ClockHandPlacement.centered)
        XCTAssertEqual(placements.minute, ClockHandPlacement.centered)
    }
}
