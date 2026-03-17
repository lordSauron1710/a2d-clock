import SwiftUI

enum ClockLumeColor: String, CaseIterable, Identifiable {
    case ember
    case amber
    case orchid
    case mint
    case aqua
    case lime
    case pearl

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .ember:
            return "Ember"
        case .amber:
            return "Amber"
        case .orchid:
            return "Orchid"
        case .mint:
            return "Mint"
        case .aqua:
            return "Aqua"
        case .lime:
            return "Lime"
        case .pearl:
            return "Pearl"
        }
    }

    var color: Color {
        switch self {
        case .ember:
            return Color(red: 1.0, green: 0.42, blue: 0.3)
        case .amber:
            return Color(red: 1.0, green: 0.78, blue: 0.25)
        case .orchid:
            return Color(red: 0.82, green: 0.67, blue: 1.0)
        case .mint:
            return Color(red: 0.55, green: 0.96, blue: 0.77)
        case .aqua:
            return Color(red: 0.42, green: 0.93, blue: 1.0)
        case .lime:
            return Color(red: 0.75, green: 1.0, blue: 0.35)
        case .pearl:
            return Color(red: 0.95, green: 0.97, blue: 1.0)
        }
    }
}
