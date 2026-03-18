import A2DClockCore
@testable import A2DClockSurface
import SwiftUI
import XCTest

final class ClockHandGeometryTests: XCTestCase {
    func testCoincidentHandsCombineIntoSingleVisibleOpacity() {
        let opacity = ClockHandGeometry.coincidentOpacity(
            hourAngle: ClockPose.radians(forClockUnits: 3),
            minuteAngle: ClockPose.radians(forClockUnits: 3),
            hourOpacity: 0.6,
            minuteOpacity: 0.5
        )

        XCTAssertNotNil(opacity)
        XCTAssertEqual(opacity ?? 0, 0.8, accuracy: 0.0001)
    }

    func testOpposedHandsDoNotCombineIntoSingleOpacity() {
        let opacity = ClockHandGeometry.coincidentOpacity(
            hourAngle: ClockPose.radians(forClockUnits: 0),
            minuteAngle: ClockPose.radians(forClockUnits: 6),
            hourOpacity: 1,
            minuteOpacity: 1
        )

        XCTAssertNil(opacity)
    }

    func testCenteredOrthogonalHandsOverlapAtTheJunction() {
        let center = CGPoint(x: 50, y: 50)
        let lineWidth: CGFloat = 20
        let reach = ClockHandGeometry.handReach(for: 50)
        let horizontal = ClockHandGeometry.path(
            center: center,
            angle: ClockPose.radians(forClockUnits: 3),
            radius: reach,
            lineWidth: lineWidth
        )
        let vertical = ClockHandGeometry.path(
            center: center,
            angle: ClockPose.radians(forClockUnits: 6),
            radius: reach,
            lineWidth: lineWidth
        )
        let junctionProbe = CGPoint(x: 52, y: 52)

        XCTAssertTrue(horizontal.contains(junctionProbe))
        XCTAssertTrue(vertical.contains(junctionProbe))
    }

    func testHandReachExtendsPastTheCellBoundaryToCloseSeams() {
        let center = CGPoint(x: 50, y: 50)
        let path = ClockHandGeometry.path(
            center: center,
            angle: ClockPose.radians(forClockUnits: 3),
            radius: ClockHandGeometry.handReach(for: 50),
            lineWidth: 10
        )

        XCTAssertGreaterThan(path.boundingRect.maxX, 100)
    }
}
