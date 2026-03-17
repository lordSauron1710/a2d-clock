import A2DClockCore
@testable import A2DClockSurface
import XCTest

final class ClockCustomizationStoreTests: XCTestCase {
    func testCustomizationRoundTripsAcrossAllSupportedStates() {
        let suiteName = "ClockCustomizationStoreTests.\(UUID().uuidString)"
        guard let defaults = UserDefaults(suiteName: suiteName) else {
            XCTFail("Failed to create isolated defaults suite")
            return
        }

        defer {
            defaults.removePersistentDomain(forName: suiteName)
        }

        let scaleSamples = [0.86, 1.0, 1.18]

        for hourFormat in ClockHourFormat.allCases {
            for dialPalette in ClockDialPalette.allCases {
                for clockScale in scaleSamples {
                    var customization = ClockCustomizationStore()
                    customization.hourFormat = hourFormat
                    customization.dialPalette = dialPalette
                    customization.clockScale = clockScale

                    customization.persist(defaults: defaults)

                    XCTAssertEqual(
                        ClockCustomizationStore.load(defaults: defaults),
                        customization
                    )
                }
            }
        }
    }

    func testLoadSupportsLegacyCompactFootprintFallback() {
        let suiteName = "ClockCustomizationStoreTests.Legacy.\(UUID().uuidString)"
        guard let defaults = UserDefaults(suiteName: suiteName) else {
            XCTFail("Failed to create isolated defaults suite")
            return
        }

        defer {
            defaults.removePersistentDomain(forName: suiteName)
        }

        defaults.set("compact", forKey: "clock.scaleOption")

        let customization = ClockCustomizationStore.load(defaults: defaults)
        XCTAssertEqual(customization.clockScale, 0.9, accuracy: 0.0001)
    }
}
