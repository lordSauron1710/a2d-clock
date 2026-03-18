import A2DClockCore
@testable import A2DClockSurface
import SwiftUI
import XCTest

final class ClockBurnInStrategyTests: XCTestCase {

    private let testViewport = CGSize(width: 2560, height: 1600)

    private var testBoardSize: CGSize {
        ClockDisplayLayout(size: testViewport).contentSize
    }

    // MARK: - Lissajous coverage

    func testSpatialDriftCoversPositiveAndNegativeXOverTwoCycles() {
        // 140 minutes covers two full 67-min Y cycles and roughly three 47-min X cycles.
        var minX: CGFloat = .infinity
        var maxX: CGFloat = -.infinity
        sample(minutes: 140, count: 1000) { date in
            let t = ClockBurnInStrategy.transform(for: date, viewportSize: testViewport, boardSize: testBoardSize)
            minX = min(minX, t.xOffset)
            maxX = max(maxX, t.xOffset)
        }

        XCTAssertLessThan(minX, -5, "Lissajous path should drift to negative X over time")
        XCTAssertGreaterThan(maxX, 5, "Lissajous path should drift to positive X over time")
    }

    func testSpatialDriftCoversPositiveAndNegativeYOverTwoCycles() {
        var minY: CGFloat = .infinity
        var maxY: CGFloat = -.infinity
        sample(minutes: 140, count: 1000) { date in
            let t = ClockBurnInStrategy.transform(for: date, viewportSize: testViewport, boardSize: testBoardSize)
            minY = min(minY, t.yOffset)
            maxY = max(maxY, t.yOffset)
        }

        XCTAssertLessThan(minY, -5, "Lissajous path should drift to negative Y over time")
        XCTAssertGreaterThan(maxY, 5, "Lissajous path should drift to positive Y over time")
    }

    // MARK: - Temporal smoothness (no discontinuous jumps)

    func testTransformOffsetDoesNotJumpMoreThanOnePointPerSecond() {
        // At the fastest Lissajous velocity (zero crossing of 47-min period at max amplitude),
        // the peak speed is well under 1pt/s for any realistic viewport.
        let base = Date(timeIntervalSinceReferenceDate: 10_000)
        let next = Date(timeIntervalSinceReferenceDate: 10_001)

        let t0 = ClockBurnInStrategy.transform(for: base, viewportSize: testViewport, boardSize: testBoardSize)
        let t1 = ClockBurnInStrategy.transform(for: next, viewportSize: testViewport, boardSize: testBoardSize)

        XCTAssertLessThan(abs(t1.xOffset - t0.xOffset), 1.0, "X should not jump more than 1pt per second")
        XCTAssertLessThan(abs(t1.yOffset - t0.yOffset), 1.0, "Y should not jump more than 1pt per second")
    }

    func testRotationDoesNotJumpMoreThanOneDegreePerSecond() {
        let base = Date(timeIntervalSinceReferenceDate: 50_000)
        let next = Date(timeIntervalSinceReferenceDate: 50_001)

        let t0 = ClockBurnInStrategy.transform(for: base, viewportSize: testViewport, boardSize: testBoardSize)
        let t1 = ClockBurnInStrategy.transform(for: next, viewportSize: testViewport, boardSize: testBoardSize)

        XCTAssertLessThan(abs(t1.rotationDegrees - t0.rotationDegrees), 1.0)
    }

    // MARK: - Luminance range

    func testLuminanceStaysWithinSafeRange() {
        // Must always be in [1 - luminanceDepth, 1.0].
        let minExpected = 1.0 - ClockBurnInStrategy.luminanceDepth
        sample(minutes: 200, count: 500) { date in
            let lum = ClockBurnInStrategy.luminance(for: date)
            XCTAssertGreaterThanOrEqual(lum, minExpected - 0.001)
            XCTAssertLessThanOrEqual(lum, 1.001)
        }
    }

    func testLuminanceCyclesBetweenMinAndMaxOverFullPeriod() {
        // Over a full 53-minute breathing period the luminance should visit both extremes.
        var minLum = Double.infinity
        var maxLum = -Double.infinity
        sample(minutes: 54, count: 1000) { date in
            let lum = ClockBurnInStrategy.luminance(for: date)
            minLum = min(minLum, lum)
            maxLum = max(maxLum, lum)
        }

        let depth = ClockBurnInStrategy.luminanceDepth
        XCTAssertLessThan(minLum, 1.0 - depth * 0.9, "Should reach near-minimum luminance within one cycle")
        XCTAssertGreaterThan(maxLum, 1.0 - depth * 0.1, "Should reach near-maximum luminance within one cycle")
    }

    // MARK: - Backdrop center bounds

    func testBackdropCenterRemainsNearCenter() {
        // The gradient center should stay well within [0.3, 0.7] to avoid hard edges.
        sample(minutes: 200, count: 500) { date in
            let center = ClockBurnInStrategy.backdropCenter(for: date)
            XCTAssertGreaterThan(center.x, 0.3)
            XCTAssertLessThan(center.x, 0.7)
            XCTAssertGreaterThan(center.y, 0.3)
            XCTAssertLessThan(center.y, 0.7)
        }
    }

    func testBackdropCenterDriftsFromItsInitialPosition() {
        // Over time the center should move — it should not stay pinned to 0.5.
        let initial = ClockBurnInStrategy.backdropCenter(for: Date(timeIntervalSinceReferenceDate: 0))
        var everDifferent = false
        sample(minutes: 200, count: 200) { date in
            let c = ClockBurnInStrategy.backdropCenter(for: date)
            if abs(c.x - initial.x) > 0.005 || abs(c.y - initial.y) > 0.005 {
                everDifferent = true
            }
        }
        XCTAssertTrue(everDifferent, "Backdrop center should drift from its initial position")
    }

    // MARK: - Scale

    func testScaleStaysNearUnity() {
        sample(minutes: 200, count: 500) { date in
            let t = ClockBurnInStrategy.transform(for: date, viewportSize: testViewport, boardSize: testBoardSize)
            XCTAssertGreaterThan(t.scale, 0.99)
            XCTAssertLessThan(t.scale, 1.01)
        }
    }

    // MARK: - Helpers

    private func sample(minutes: Double, count: Int, body: (Date) -> Void) {
        let total = minutes * 60
        for i in 0..<count {
            let t = Double(i) / Double(count - 1) * total
            body(Date(timeIntervalSinceReferenceDate: t))
        }
    }
}
