import SwiftUI

enum ClockDialPalette: String, CaseIterable, Identifiable {
    case porcelain
    case lagoon
    case haze
    case cinder
    case grove
    case saffron

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .porcelain:
            return "Porcelain"
        case .lagoon:
            return "Lagoon"
        case .haze:
            return "Haze"
        case .cinder:
            return "Cinder"
        case .grove:
            return "Grove"
        case .saffron:
            return "Saffron"
        }
    }

    var previewSwatches: [Color] {
        descriptor.dayFaceFills
    }

    var descriptor: ClockPaletteDescriptor {
        switch self {
        case .porcelain:
            return ClockPaletteDescriptor(
                dayBackgroundTop: Color(red: 0.95, green: 0.94, blue: 0.92),
                dayBackgroundBottom: Color(red: 0.84, green: 0.84, blue: 0.85),
                nightBackgroundTop: Color(red: 0.1, green: 0.11, blue: 0.13),
                nightBackgroundBottom: Color(red: 0.03, green: 0.04, blue: 0.05),
                dayFaceFills: [
                    Color(red: 0.98, green: 0.97, blue: 0.95),
                    Color(red: 0.94, green: 0.95, blue: 0.96),
                    Color(red: 0.95, green: 0.94, blue: 0.91),
                    Color(red: 0.9, green: 0.92, blue: 0.93)
                ],
                nightFaceFills: [
                    Color(red: 0.16, green: 0.18, blue: 0.2),
                    Color(red: 0.14, green: 0.16, blue: 0.18),
                    Color(red: 0.18, green: 0.17, blue: 0.19),
                    Color(red: 0.12, green: 0.14, blue: 0.16)
                ],
                accentOne: Color(red: 0.2, green: 0.39, blue: 0.78),
                accentTwo: Color(red: 0.92, green: 0.75, blue: 0.23),
                accentThree: Color(red: 0.86, green: 0.28, blue: 0.22)
            )
        case .lagoon:
            return ClockPaletteDescriptor(
                dayBackgroundTop: Color(red: 0.83, green: 0.96, blue: 0.98),
                dayBackgroundBottom: Color(red: 0.7, green: 0.86, blue: 0.91),
                nightBackgroundTop: Color(red: 0.04, green: 0.11, blue: 0.16),
                nightBackgroundBottom: Color(red: 0.01, green: 0.05, blue: 0.09),
                dayFaceFills: [
                    Color(red: 0.84, green: 0.98, blue: 0.98),
                    Color(red: 0.72, green: 0.93, blue: 0.96),
                    Color(red: 0.82, green: 0.96, blue: 0.94),
                    Color(red: 0.75, green: 0.9, blue: 0.93)
                ],
                nightFaceFills: [
                    Color(red: 0.08, green: 0.22, blue: 0.29),
                    Color(red: 0.06, green: 0.18, blue: 0.24),
                    Color(red: 0.09, green: 0.24, blue: 0.31),
                    Color(red: 0.05, green: 0.16, blue: 0.21)
                ],
                accentOne: Color(red: 0.04, green: 0.75, blue: 0.82),
                accentTwo: Color(red: 0.95, green: 0.95, blue: 0.98),
                accentThree: Color(red: 0.14, green: 0.49, blue: 0.88)
            )
        case .haze:
            return ClockPaletteDescriptor(
                dayBackgroundTop: Color(red: 0.9, green: 0.94, blue: 0.98),
                dayBackgroundBottom: Color(red: 0.79, green: 0.84, blue: 0.9),
                nightBackgroundTop: Color(red: 0.08, green: 0.1, blue: 0.16),
                nightBackgroundBottom: Color(red: 0.04, green: 0.05, blue: 0.08),
                dayFaceFills: [
                    Color(red: 0.93, green: 0.97, blue: 1.0),
                    Color(red: 0.86, green: 0.91, blue: 0.97),
                    Color(red: 0.89, green: 0.92, blue: 0.96),
                    Color(red: 0.81, green: 0.87, blue: 0.93)
                ],
                nightFaceFills: [
                    Color(red: 0.13, green: 0.16, blue: 0.23),
                    Color(red: 0.11, green: 0.13, blue: 0.19),
                    Color(red: 0.15, green: 0.18, blue: 0.26),
                    Color(red: 0.09, green: 0.11, blue: 0.16)
                ],
                accentOne: Color(red: 0.29, green: 0.56, blue: 0.94),
                accentTwo: Color(red: 0.72, green: 0.83, blue: 0.96),
                accentThree: Color(red: 0.34, green: 0.42, blue: 0.71)
            )
        case .cinder:
            return ClockPaletteDescriptor(
                dayBackgroundTop: Color(red: 0.92, green: 0.9, blue: 0.88),
                dayBackgroundBottom: Color(red: 0.78, green: 0.75, blue: 0.74),
                nightBackgroundTop: Color(red: 0.13, green: 0.1, blue: 0.1),
                nightBackgroundBottom: Color(red: 0.05, green: 0.03, blue: 0.04),
                dayFaceFills: [
                    Color(red: 0.95, green: 0.92, blue: 0.9),
                    Color(red: 0.87, green: 0.84, blue: 0.83),
                    Color(red: 0.92, green: 0.89, blue: 0.86),
                    Color(red: 0.8, green: 0.77, blue: 0.76)
                ],
                nightFaceFills: [
                    Color(red: 0.24, green: 0.16, blue: 0.14),
                    Color(red: 0.19, green: 0.12, blue: 0.11),
                    Color(red: 0.28, green: 0.18, blue: 0.15),
                    Color(red: 0.15, green: 0.1, blue: 0.1)
                ],
                accentOne: Color(red: 0.95, green: 0.67, blue: 0.33),
                accentTwo: Color(red: 0.96, green: 0.86, blue: 0.65),
                accentThree: Color(red: 0.79, green: 0.33, blue: 0.22)
            )
        case .grove:
            return ClockPaletteDescriptor(
                dayBackgroundTop: Color(red: 0.89, green: 0.95, blue: 0.87),
                dayBackgroundBottom: Color(red: 0.75, green: 0.85, blue: 0.73),
                nightBackgroundTop: Color(red: 0.05, green: 0.12, blue: 0.08),
                nightBackgroundBottom: Color(red: 0.02, green: 0.06, blue: 0.04),
                dayFaceFills: [
                    Color(red: 0.92, green: 0.98, blue: 0.9),
                    Color(red: 0.8, green: 0.91, blue: 0.79),
                    Color(red: 0.85, green: 0.96, blue: 0.84),
                    Color(red: 0.73, green: 0.84, blue: 0.72)
                ],
                nightFaceFills: [
                    Color(red: 0.08, green: 0.19, blue: 0.13),
                    Color(red: 0.06, green: 0.15, blue: 0.1),
                    Color(red: 0.09, green: 0.22, blue: 0.14),
                    Color(red: 0.04, green: 0.11, blue: 0.08)
                ],
                accentOne: Color(red: 0.2, green: 0.74, blue: 0.41),
                accentTwo: Color(red: 0.79, green: 0.94, blue: 0.53),
                accentThree: Color(red: 0.11, green: 0.47, blue: 0.28)
            )
        case .saffron:
            return ClockPaletteDescriptor(
                dayBackgroundTop: Color(red: 0.99, green: 0.88, blue: 0.58),
                dayBackgroundBottom: Color(red: 0.94, green: 0.73, blue: 0.3),
                nightBackgroundTop: Color(red: 0.16, green: 0.1, blue: 0.03),
                nightBackgroundBottom: Color(red: 0.08, green: 0.05, blue: 0.01),
                dayFaceFills: [
                    Color(red: 0.99, green: 0.92, blue: 0.69),
                    Color(red: 0.98, green: 0.84, blue: 0.5),
                    Color(red: 1.0, green: 0.9, blue: 0.61),
                    Color(red: 0.94, green: 0.76, blue: 0.34)
                ],
                nightFaceFills: [
                    Color(red: 0.29, green: 0.19, blue: 0.04),
                    Color(red: 0.24, green: 0.15, blue: 0.03),
                    Color(red: 0.34, green: 0.22, blue: 0.05),
                    Color(red: 0.18, green: 0.12, blue: 0.03)
                ],
                accentOne: Color(red: 0.99, green: 0.83, blue: 0.11),
                accentTwo: Color(red: 1.0, green: 0.95, blue: 0.84),
                accentThree: Color(red: 0.85, green: 0.4, blue: 0.04)
            )
        }
    }
}

struct ClockPaletteDescriptor {
    let dayBackgroundTop: Color
    let dayBackgroundBottom: Color
    let nightBackgroundTop: Color
    let nightBackgroundBottom: Color
    let dayFaceFills: [Color]
    let nightFaceFills: [Color]
    let accentOne: Color
    let accentTwo: Color
    let accentThree: Color
}
