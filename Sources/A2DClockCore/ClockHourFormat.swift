import Foundation

public enum ClockHourFormat: String, CaseIterable, Identifiable, Sendable {
    case twelve
    case twentyFour

    public var id: String {
        rawValue
    }

    public func displayHour(from hour: Int) -> Int {
        switch self {
        case .twentyFour:
            return hour
        case .twelve:
            let normalized = hour % 12
            return normalized == 0 ? 12 : normalized
        }
    }
}
