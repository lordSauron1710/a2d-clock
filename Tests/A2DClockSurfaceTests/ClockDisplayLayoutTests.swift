import A2DClockCore
@testable import A2DClockSurface
import XCTest

final class ClockDisplayLayoutTests: XCTestCase {
    func testLayoutMaintainsPositiveGeometryAcrossViewportMatrix() {
        let sizes = [
            CGSize(width: 900, height: 600),
            CGSize(width: 1440, height: 900),
            CGSize(width: 2560, height: 1600)
        ]

        for size in sizes {
            let layout = ClockDisplayLayout(size: size)

            XCTAssertGreaterThan(layout.cellSize, 0)
            XCTAssertGreaterThan(layout.contentSize.width, 0)
            XCTAssertGreaterThan(layout.contentSize.height, 0)
            XCTAssertLessThanOrEqual(layout.contentSize.width, size.width * 1.03)
            XCTAssertLessThanOrEqual(layout.contentSize.height, size.height * 0.91)

            for slot in ClockSlot.all {
                let point = layout.position(for: slot)
                XCTAssertGreaterThan(point.x, 0)
                XCTAssertLessThan(point.x, size.width)
                XCTAssertGreaterThan(point.y, 0)
                XCTAssertLessThan(point.y, size.height)
            }
        }
    }
}
