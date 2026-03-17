import A2DClockCore
import Foundation

public struct ClockCustomizationStore: Equatable {
    var hourFormat: ClockHourFormat = .twentyFour
    var dialPalette: ClockDialPalette = .porcelain
    var clockScale: Double = 1.0

    private enum Key {
        static let hourFormat = "clock.hourFormat"
        static let dialPalette = "clock.dialPalette"
        static let clockScale = "clock.clockScale"
        static let legacyScaleOption = "clock.scaleOption"
    }

    public static func load(defaults: UserDefaults = .standard) -> Self {
        let storedClockScale = defaults.object(forKey: Key.clockScale) as? Double
        let fallbackClockScale = legacyClockScale(defaults: defaults)

        return Self(
            hourFormat: ClockHourFormat(rawValue: defaults.string(forKey: Key.hourFormat) ?? "") ?? .twentyFour,
            dialPalette: ClockDialPalette(rawValue: defaults.string(forKey: Key.dialPalette) ?? "") ?? .porcelain,
            clockScale: (storedClockScale ?? fallbackClockScale).clamped(to: Self.clockScaleRange)
        )
    }

    public func persist(defaults: UserDefaults = .standard) {
        defaults.set(hourFormat.rawValue, forKey: Key.hourFormat)
        defaults.set(dialPalette.rawValue, forKey: Key.dialPalette)
        defaults.set(clockScale, forKey: Key.clockScale)
        defaults.removeObject(forKey: "clock.appearanceMode")
        defaults.removeObject(forKey: "clock.lumeColor")
    }

    static let clockScaleRange = 0.86 ... 1.18

    var clockScaleLabel: String {
        "\(Int((clockScale * 100).rounded()))%"
    }

    private static func legacyClockScale(defaults: UserDefaults) -> Double {
        switch defaults.string(forKey: Key.legacyScaleOption) {
        case "compact":
            return 0.9
        default:
            return 1.0
        }
    }
}
