import A2DClockCore
import Foundation

public struct ClockCustomizationStore: Equatable {
    var appearanceMode: ClockAppearanceMode = .system
    var hourFormat: ClockHourFormat = .twentyFour
    var dialPalette: ClockDialPalette = .porcelain

    private enum Key {
        static let appearanceMode = "clock.appearanceMode"
        static let hourFormat = "clock.hourFormat"
        static let dialPalette = "clock.dialPalette"
    }

    public static func load(defaults: UserDefaults = .standard) -> Self {
        return Self(
            appearanceMode: ClockAppearanceMode(rawValue: defaults.string(forKey: Key.appearanceMode) ?? "") ?? .system,
            hourFormat: ClockHourFormat(rawValue: defaults.string(forKey: Key.hourFormat) ?? "") ?? .twentyFour,
            dialPalette: ClockDialPalette(rawValue: defaults.string(forKey: Key.dialPalette) ?? "") ?? .porcelain
        )
    }

    public func persist(defaults: UserDefaults = .standard) {
        defaults.set(appearanceMode.rawValue, forKey: Key.appearanceMode)
        defaults.set(hourFormat.rawValue, forKey: Key.hourFormat)
        defaults.set(dialPalette.rawValue, forKey: Key.dialPalette)
        defaults.removeObject(forKey: "clock.clockSize")
        defaults.removeObject(forKey: "clock.clockScale")
        defaults.removeObject(forKey: "clock.scaleOption")
        defaults.removeObject(forKey: "clock.lumeColor")
    }
}
