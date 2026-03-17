import Foundation

struct ClockCustomizationStore: Equatable {
    var appearanceMode: ClockAppearanceMode = .system
    var dialPalette: ClockDialPalette = .porcelain
    var scaleOption: ClockScaleOption = .gallery
    var movementStyle: ClockMovementStyle = .sweep
    var lumeColor: ClockLumeColor = .aqua
    var isStudioPresented = false

    private enum Key {
        static let appearanceMode = "clock.appearanceMode"
        static let dialPalette = "clock.dialPalette"
        static let scaleOption = "clock.scaleOption"
        static let movementStyle = "clock.movementStyle"
        static let lumeColor = "clock.lumeColor"
    }

    static func load(defaults: UserDefaults = .standard) -> Self {
        Self(
            appearanceMode: ClockAppearanceMode(rawValue: defaults.string(forKey: Key.appearanceMode) ?? "") ?? .system,
            dialPalette: ClockDialPalette(rawValue: defaults.string(forKey: Key.dialPalette) ?? "") ?? .porcelain,
            scaleOption: ClockScaleOption(rawValue: defaults.string(forKey: Key.scaleOption) ?? "") ?? .gallery,
            movementStyle: ClockMovementStyle(rawValue: defaults.string(forKey: Key.movementStyle) ?? "") ?? .sweep,
            lumeColor: ClockLumeColor(rawValue: defaults.string(forKey: Key.lumeColor) ?? "") ?? .aqua
        )
    }

    func persist(defaults: UserDefaults = .standard) {
        defaults.set(appearanceMode.rawValue, forKey: Key.appearanceMode)
        defaults.set(dialPalette.rawValue, forKey: Key.dialPalette)
        defaults.set(scaleOption.rawValue, forKey: Key.scaleOption)
        defaults.set(movementStyle.rawValue, forKey: Key.movementStyle)
        defaults.set(lumeColor.rawValue, forKey: Key.lumeColor)
    }
}
