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

        for appearanceMode in ClockAppearanceMode.allCases {
            for hourFormat in ClockHourFormat.allCases {
                for dialPalette in ClockDialPalette.allCases {
                    var customization = ClockCustomizationStore()
                    customization.appearanceMode = appearanceMode
                    customization.hourFormat = hourFormat
                    customization.dialPalette = dialPalette

                    customization.persist(defaults: defaults)

                    XCTAssertEqual(
                        ClockCustomizationStore.load(defaults: defaults),
                        customization
                    )
                }
            }
        }
    }

    func testLoadIgnoresLegacyScaleControlsAndUsesFixedDefaultSize() {
        let suiteName = "ClockCustomizationStoreTests.Legacy.\(UUID().uuidString)"
        guard let defaults = UserDefaults(suiteName: suiteName) else {
            XCTFail("Failed to create isolated defaults suite")
            return
        }

        defer {
            defaults.removePersistentDomain(forName: suiteName)
        }

        defaults.set(0.94, forKey: "clock.clockSize")
        defaults.set(1.18, forKey: "clock.clockScale")
        defaults.set("compact", forKey: "clock.scaleOption")

        let customization = ClockCustomizationStore.load(defaults: defaults)
        XCTAssertEqual(customization.clockScale, ClockCustomizationStore.defaultClockScale, accuracy: 0.0001)
    }
}
