import A2DClockCore
import Foundation

public struct ClockCustomizationStore: Equatable {
    var appearanceMode: ClockAppearanceMode = .system
    var hourFormat: ClockHourFormat = .twentyFour
    var dialPalette: ClockDialPalette = .porcelain
    var scaleOption: ClockScaleOption = .gallery
    var lumeColor: ClockLumeColor = .aqua

    private enum Key {
        static let appearanceMode = "clock.appearanceMode"
        static let hourFormat = "clock.hourFormat"
        static let dialPalette = "clock.dialPalette"
        static let scaleOption = "clock.scaleOption"
        static let lumeColor = "clock.lumeColor"
    }

    public static func load(defaults: UserDefaults = .standard) -> Self {
        Self(
            appearanceMode: ClockAppearanceMode(rawValue: defaults.string(forKey: Key.appearanceMode) ?? "") ?? .system,
            hourFormat: ClockHourFormat(rawValue: defaults.string(forKey: Key.hourFormat) ?? "") ?? .twentyFour,
            dialPalette: ClockDialPalette(rawValue: defaults.string(forKey: Key.dialPalette) ?? "") ?? .porcelain,
            scaleOption: ClockScaleOption(rawValue: defaults.string(forKey: Key.scaleOption) ?? "") ?? .gallery,
            lumeColor: ClockLumeColor(rawValue: defaults.string(forKey: Key.lumeColor) ?? "") ?? .aqua
        )
    }

    public func persist(defaults: UserDefaults = .standard) {
        defaults.set(appearanceMode.rawValue, forKey: Key.appearanceMode)
        defaults.set(hourFormat.rawValue, forKey: Key.hourFormat)
        defaults.set(dialPalette.rawValue, forKey: Key.dialPalette)
        defaults.set(scaleOption.rawValue, forKey: Key.scaleOption)
        defaults.set(lumeColor.rawValue, forKey: Key.lumeColor)
    }
}
