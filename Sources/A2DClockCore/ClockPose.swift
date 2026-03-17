import Foundation

public struct ClockPose: Equatable, Sendable {
    public var hourAngle: Double
    public var minuteAngle: Double

    public init(hourAngle: Double, minuteAngle: Double) {
        self.hourAngle = Self.normalize(hourAngle)
        self.minuteAngle = Self.normalize(minuteAngle)
    }

    public static func clockUnits(_ hour: Double, _ minute: Double) -> Self {
        Self(
            hourAngle: radians(forClockUnits: hour),
            minuteAngle: radians(forClockUnits: minute)
        )
    }

    public static func radians(forClockUnits units: Double) -> Double {
        (units / 12.0) * (.pi * 2.0)
    }

    public func interpolated(to target: Self, progress: Double) -> Self {
        let clamped = progress.clamped(to: 0.0 ... 1.0)
        return Self(
            hourAngle: hourAngle + shortestDelta(from: hourAngle, to: target.hourAngle) * clamped,
            minuteAngle: minuteAngle + shortestDelta(from: minuteAngle, to: target.minuteAngle) * clamped
        )
    }

    public static func normalize(_ angle: Double) -> Double {
        let turn = .pi * 2.0
        let remainder = angle.truncatingRemainder(dividingBy: turn)
        return remainder >= 0.0 ? remainder : remainder + turn
    }

    private func shortestDelta(from start: Double, to end: Double) -> Double {
        let turn = .pi * 2.0
        var delta = (end - start).truncatingRemainder(dividingBy: turn)
        if delta > .pi {
            delta -= turn
        } else if delta < -.pi {
            delta += turn
        }
        return delta
    }
}

extension Double {
    func clamped(to range: ClosedRange<Double>) -> Double {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
