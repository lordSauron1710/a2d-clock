import SwiftUI

enum ClockDialPalette: String, CaseIterable, Identifiable {
    case porcelain
    case grove
    case saffron
    case marina
    case blossom
    case crimson

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .porcelain:
            return "Porcelain"
        case .grove:
            return "Grove"
        case .saffron:
            return "Saffron"
        case .marina:
            return "Marina"
        case .blossom:
            return "Blossom"
        case .crimson:
            return "Crimson"
        }
    }

    var dayBackground: Color {
        switch self {
        case .porcelain:
            return Color(red: 0.92, green: 0.9, blue: 0.86)
        case .grove:
            return Color(red: 0.77, green: 0.83, blue: 0.74)
        case .saffron:
            return Color(red: 0.9, green: 0.75, blue: 0.46)
        case .marina:
            return Color(red: 0.71, green: 0.8, blue: 0.88)
        case .blossom:
            return Color(red: 0.85, green: 0.73, blue: 0.78)
        case .crimson:
            return Color(red: 0.88, green: 0.62, blue: 0.62)
        }
    }

    var nightLume: Color {
        switch self {
        case .porcelain:
            return Color(red: 0.93, green: 0.96, blue: 1.0)
        case .grove:
            return Color(red: 0.66, green: 0.96, blue: 0.78)
        case .saffron:
            return Color(red: 1.0, green: 0.84, blue: 0.34)
        case .marina:
            return Color(red: 0.48, green: 0.9, blue: 1.0)
        case .blossom:
            return Color(red: 0.96, green: 0.72, blue: 0.82)
        case .crimson:
            return Color(red: 1.0, green: 0.36, blue: 0.36)
        }
    }

    var previewColor: Color {
        dayBackground
    }
}
