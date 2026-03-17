import Foundation

enum ClockScaleOption: String, CaseIterable, Identifiable {
    case gallery
    case compact

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .gallery:
            return "Gallery"
        case .compact:
            return "Compact"
        }
    }

    var detail: String {
        switch self {
        case .gallery:
            return "Room-first proportions"
        case .compact:
            return "Tighter footprint"
        }
    }

    var widthFactor: CGFloat {
        switch self {
        case .gallery:
            return 0.78
        case .compact:
            return 0.68
        }
    }

    var heightFactor: CGFloat {
        switch self {
        case .gallery:
            return 0.28
        case .compact:
            return 0.24
        }
    }

    var faceScale: CGFloat {
        switch self {
        case .gallery:
            return 1.0
        case .compact:
            return 0.88
        }
    }
}
