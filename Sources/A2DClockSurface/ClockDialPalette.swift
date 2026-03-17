import SwiftUI

enum ClockDialPalette: String, CaseIterable, Identifiable {
    case porcelain
    case grove
    case saffron
    case marina
    case blossom

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
        }
    }

    var previewColor: Color {
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
        }
    }
}
