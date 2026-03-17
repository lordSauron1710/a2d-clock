import A2DClockCore
import Foundation

enum ClockMovementStyle: String, CaseIterable, Identifiable {
    case step
    case sweep
    case glide

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .step:
            return "Step"
        case .sweep:
            return "Sweep"
        case .glide:
            return "Glide"
        }
    }

    var detail: String {
        switch self {
        case .step:
            return "Crisp staged moves"
        case .sweep:
            return "Mechanical flourish"
        case .glide:
            return "Continuous flow"
        }
    }

    var transitionDuration: Double {
        switch self {
        case .step:
            return 1.5
        case .sweep:
            return 2.4
        case .glide:
            return 1.9
        }
    }

    var flourishSplit: Double {
        switch self {
        case .step:
            return 0.18
        case .sweep:
            return 0.34
        case .glide:
            return 0.12
        }
    }

    var transitionStyle: ClockTransitionStyle {
        switch self {
        case .step:
            return .step
        case .sweep:
            return .sweep
        case .glide:
            return .glide
        }
    }
}
