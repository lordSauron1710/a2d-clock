import AppKit
@testable import A2DClockSurface
import SwiftUI
import XCTest

final class ClockThemeTests: XCTestCase {
    func testThemeUsesSelectedBackgroundAndFixedBlackHands() {
        for dialPalette in ClockDialPalette.allCases {
            let theme = ClockTheme.make(palette: dialPalette)

            assertColor(theme.backgroundColor, closeTo: dialPalette.previewColor)
            assertColor(theme.handColor, closeTo: .black)
        }
    }

    private func assertColor(
        _ actual: Color,
        closeTo expected: Color,
        accuracy: CGFloat = 0.01,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let actualRGBA = rgba(actual)
        let expectedRGBA = rgba(expected)

        XCTAssertEqual(actualRGBA.red, expectedRGBA.red, accuracy: accuracy, file: file, line: line)
        XCTAssertEqual(actualRGBA.green, expectedRGBA.green, accuracy: accuracy, file: file, line: line)
        XCTAssertEqual(actualRGBA.blue, expectedRGBA.blue, accuracy: accuracy, file: file, line: line)
        XCTAssertEqual(actualRGBA.alpha, expectedRGBA.alpha, accuracy: accuracy, file: file, line: line)
    }

    private func rgba(_ color: Color) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let resolvedColor = NSColor(color).usingColorSpace(.deviceRGB) ?? NSColor.clear
        return (
            resolvedColor.redComponent,
            resolvedColor.greenComponent,
            resolvedColor.blueComponent,
            resolvedColor.alphaComponent
        )
    }
}
