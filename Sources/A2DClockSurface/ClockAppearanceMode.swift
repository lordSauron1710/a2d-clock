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

    var detail: String {
        switch self {
        case .system:
            return "Follow the system appearance."
        case .day:
            return "Use background color mode."
        case .night:
            return "Use lume and glow mode."
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
