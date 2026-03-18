@testable import A2DClockSurface
import XCTest

final class ClockStudioPanelLayoutTests: XCTestCase {
    func testPanelHeightClampsToPreferredMaximum() {
        XCTAssertEqual(StudioPanelLayout.panelHeight(containerHeight: 2_000), 680, accuracy: 0.0001)
    }

    func testPanelHeightRespectsAvailableViewportSpace() {
        XCTAssertEqual(
            StudioPanelLayout.panelHeight(containerHeight: 700),
            644,
            accuracy: 0.0001
        )
    }

    func testPanelHeightNeverDropsBelowTheAvailableSpace() {
        XCTAssertEqual(
            StudioPanelLayout.panelHeight(containerHeight: 540),
            484,
            accuracy: 0.0001
        )
    }
}
