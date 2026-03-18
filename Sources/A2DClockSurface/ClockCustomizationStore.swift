import A2DClockCore
import Foundation

public struct ClockCustomizationStore: Equatable {
    static let defaultClockScale = 0.28

    var appearanceMode: ClockAppearanceMode = .system
    var hourFormat: ClockHourFormat = .twentyFour
    var dialPalette: ClockDialPalette = .porcelain
    var clockScale: Double = Self.defaultClockScale

    private enum Key {
        static let appearanceMode = "clock.appearanceMode"
        static let hourFormat = "clock.hourFormat"
        static let dialPalette = "clock.dialPalette"
        static let normalizedClockScale = "clock.clockSize"
        static let legacyResolvedClockScale = "clock.clockScale"
        static let legacyScaleOption = "clock.scaleOption"
    }

    public static func load(defaults: UserDefaults = .standard) -> Self {
        return Self(
            appearanceMode: ClockAppearanceMode(rawValue: defaults.string(forKey: Key.appearanceMode) ?? "") ?? .system,
            hourFormat: ClockHourFormat(rawValue: defaults.string(forKey: Key.hourFormat) ?? "") ?? .twentyFour,
            dialPalette: ClockDialPalette(rawValue: defaults.string(forKey: Key.dialPalette) ?? "") ?? .porcelain,
            clockScale: Self.defaultClockScale
        )
    }

    public func persist(defaults: UserDefaults = .standard) {
        defaults.set(appearanceMode.rawValue, forKey: Key.appearanceMode)
        defaults.set(hourFormat.rawValue, forKey: Key.hourFormat)
        defaults.set(dialPalette.rawValue, forKey: Key.dialPalette)
        defaults.removeObject(forKey: Key.normalizedClockScale)
        defaults.removeObject(forKey: Key.legacyResolvedClockScale)
        defaults.removeObject(forKey: Key.legacyScaleOption)
        defaults.removeObject(forKey: "clock.lumeColor")
    }

    static let clockScaleRange = 0.0 ... 1.0
    private static let resolvedClockScaleRange = 0.86 ... 1.18

    var clockScaleLabel: String {
        "\(Int((clockScale.clamped(to: Self.clockScaleRange) * 100).rounded()))%"
    }

    static func resolvedClockScale(for progress: Double) -> Double {
        let clampedProgress = progress.clamped(to: clockScaleRange)
        return resolvedClockScaleRange.lowerBound
            + ((resolvedClockScaleRange.upperBound - resolvedClockScaleRange.lowerBound) * clampedProgress)
    }
}
