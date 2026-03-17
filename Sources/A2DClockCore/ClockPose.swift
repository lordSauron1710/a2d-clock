import Foundation

public struct ClockPose: Equatable, Sendable {
    public var hourAngle: Double
    public var minuteAngle: Double
    public var hourOpacity: Double
    public var minuteOpacity: Double

    public init(
        hourAngle: Double,
        minuteAngle: Double,
        hourOpacity: Double = 1.0,
        minuteOpacity: Double = 1.0
    ) {
        self.hourAngle = Self.normalize(hourAngle)
        self.minuteAngle = Self.normalize(minuteAngle)
        self.hourOpacity = hourOpacity.clamped(to: 0.0 ... 1.0)
        self.minuteOpacity = minuteOpacity.clamped(to: 0.0 ... 1.0)
    }

    public static func clockUnits(
        _ hour: Double,
        _ minute: Double,
        hourOpacity: Double = 1.0,
        minuteOpacity: Double = 1.0
    ) -> Self {
        Self(
            hourAngle: radians(forClockUnits: hour),
            minuteAngle: radians(forClockUnits: minute),
            hourOpacity: hourOpacity,
            minuteOpacity: minuteOpacity
        )
    }

    public static func blank(
        restingHour: Double = 7.5,
        restingMinute: Double = 7.5
    ) -> Self {
        clockUnits(
            restingHour,
            restingMinute,
            hourOpacity: 0.0,
            minuteOpacity: 0.0
        )
    }

    public static func hourOnly(
        _ hour: Double,
        restingMinute: Double = 7.5
    ) -> Self {
        clockUnits(
            hour,
            restingMinute,
            hourOpacity: 1.0,
            minuteOpacity: 0.0
        )
    }

    public static func minuteOnly(
        _ minute: Double,
        restingHour: Double = 7.5
    ) -> Self {
        clockUnits(
            restingHour,
            minute,
            hourOpacity: 0.0,
            minuteOpacity: 1.0
        )
    }

    public static func radians(forClockUnits units: Double) -> Double {
        (units / 12.0) * (.pi * 2.0)
    }

    public var visibleOpacity: Double {
        max(hourOpacity, minuteOpacity)
    }

    public func withVisibility(
        hourOpacity: Double? = nil,
        minuteOpacity: Double? = nil
    ) -> Self {
        Self(
            hourAngle: hourAngle,
            minuteAngle: minuteAngle,
            hourOpacity: hourOpacity ?? self.hourOpacity,
            minuteOpacity: minuteOpacity ?? self.minuteOpacity
        )
    }

    public func interpolated(to target: Self, progress: Double) -> Self {
        let clamped = progress.clamped(to: 0.0 ... 1.0)
        return Self(
            hourAngle: hourAngle + clockwiseDelta(from: hourAngle, to: target.hourAngle) * clamped,
            minuteAngle: minuteAngle + clockwiseDelta(from: minuteAngle, to: target.minuteAngle) * clamped,
            hourOpacity: hourOpacity + ((target.hourOpacity - hourOpacity) * clamped),
            minuteOpacity: minuteOpacity + ((target.minuteOpacity - minuteOpacity) * clamped)
        )
    }

    public static func normalize(_ angle: Double) -> Double {
        let turn = .pi * 2.0
        let remainder = angle.truncatingRemainder(dividingBy: turn)
        return remainder >= 0.0 ? remainder : remainder + turn
    }

    private func clockwiseDelta(from start: Double, to end: Double) -> Double {
        let turn = .pi * 2.0
        let normalizedStart = Self.normalize(start)
        let normalizedEnd = Self.normalize(end)
        var delta = normalizedEnd - normalizedStart
        if delta < 0 {
            delta += turn
        }
        return delta
    }
}

extension Double {
    public func clamped(to range: ClosedRange<Double>) -> Double {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
