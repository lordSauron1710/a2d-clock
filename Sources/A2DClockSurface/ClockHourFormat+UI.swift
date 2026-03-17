import A2DClockCore

extension ClockHourFormat {
    var title: String {
        switch self {
        case .twelve:
            return "12-Hour"
        case .twentyFour:
            return "24-Hour"
        }
    }

    var detail: String {
        switch self {
        case .twelve:
            return "Classic watch-style display"
        case .twentyFour:
            return "Continuous instrument time"
        }
    }
}
