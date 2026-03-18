@testable import A2DClockSurface
import SwiftUI
import XCTest

final class ClockAppearanceModeTests: XCTestCase {
    func testResolvedColorSchemeMatchesAllModeCombinations() {
        for systemColorScheme in [ColorScheme.light, .dark] {
            XCTAssertEqual(
                ClockAppearanceMode.system.resolvedColorScheme(systemColorScheme: systemColorScheme),
                systemColorScheme
            )
            XCTAssertEqual(
                ClockAppearanceMode.day.resolvedColorScheme(systemColorScheme: systemColorScheme),
                .light
            )
            XCTAssertEqual(
                ClockAppearanceMode.night.resolvedColorScheme(systemColorScheme: systemColorScheme),
                .dark
            )
        }
    }
}
