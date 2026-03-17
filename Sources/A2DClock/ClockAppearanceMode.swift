import SwiftUI

enum ClockAppearanceMode: String, CaseIterable, Identifiable {
    case system
    case day
    case night

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .system:
            return "Auto"
        case .day:
            return "Day"
        case .night:
            return "Night"
        }
    }

    var symbolName: String {
        switch self {
        case .system:
            return "circle.lefthalf.filled"
        case .day:
            return "sun.max.fill"
        case .night:
            return "moon.fill"
        }
    }

    func resolvedColorScheme(systemColorScheme: ColorScheme) -> ColorScheme {
        switch self {
        case .system:
            return systemColorScheme
        case .day:
            return .light
        case .night:
            return .dark
        }
    }
}
