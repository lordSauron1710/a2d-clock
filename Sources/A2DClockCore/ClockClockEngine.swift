import Foundation

public struct ClockClockFrame: Equatable, Sendable {
    public let digits: [Int]
    public let poses: [ClockPose]
    public let colonVisible: Bool
}

public struct ClockClockEngine: Sendable {
    public var hourFormat: ClockHourFormat
    public var transitionDuration: Double

    public init(
        hourFormat: ClockHourFormat = .twentyFour,
        transitionDuration: Double = 2.0
    ) {
        self.hourFormat = hourFormat
        self.transitionDuration = transitionDuration
    }

    public func digits(
        for date: Date,
        calendar: Calendar = .autoupdatingCurrent
    ) -> [Int] {
        let components = calendar.dateComponents([.hour, .minute], from: date)
        let hour = hourFormat.displayHour(from: components.hour ?? 0)
        let minute = components.minute ?? 0

        return [
            hour / 10,
            hour % 10,
            minute / 10,
            minute % 10
        ]
    }

    public func frame(
        for date: Date,
        calendar: Calendar = .autoupdatingCurrent
    ) -> ClockClockFrame {
        let currentDigits = digits(for: date, calendar: calendar)
        let currentPoses = DigitGlyph.poses(for: currentDigits)

        let components = calendar.dateComponents([.second, .nanosecond], from: date)
        let seconds = Double(components.second ?? 0)
        let nanoseconds = Double(components.nanosecond ?? 0)
        let secondsIntoMinute = seconds + (nanoseconds / 1_000_000_000.0)
        let colonVisible = Int(seconds.rounded(.down)) % 2 == 0

        guard secondsIntoMinute < transitionDuration else {
            return ClockClockFrame(
                digits: currentDigits,
                poses: currentPoses,
                colonVisible: colonVisible
            )
        }

        let previousDate = date.addingTimeInterval(-60.0)
        let previousDigits = digits(for: previousDate, calendar: calendar)
        let previousPoses = DigitGlyph.poses(for: previousDigits)
        let minuteKey = Int(floor(date.timeIntervalSinceReferenceDate / 60.0))
        let progress = smoothstep(secondsIntoMinute / transitionDuration)

        return ClockClockFrame(
            digits: currentDigits,
            poses: transitionPoses(
                from: previousPoses,
                to: currentPoses,
                progress: progress,
                minuteKey: minuteKey
            ),
            colonVisible: colonVisible
        )
    }

    private func transitionPoses(
        from previous: [ClockPose],
        to target: [ClockPose],
        progress: Double,
        minuteKey: Int
    ) -> [ClockPose] {
        guard !previous.isEmpty else {
            return target
        }

        return ClockSlot.all.enumerated().map { index, slot in
            animatedPose(
                from: previous[index],
                to: target[index],
                slot: slot,
                progress: progress,
                minuteKey: minuteKey
            )
        }
    }

    private func animatedPose(
        from previous: ClockPose,
        to target: ClockPose,
        slot: ClockSlot,
        progress: Double,
        minuteKey: Int
    ) -> ClockPose {
        let distance = slotDistance(from: ClockSlot.logicalCenter, to: slot.position)
        let localDelay = (distance * 0.034) + (Double(slot.row) * 0.02) + (Double(slot.column) * 0.012)
        let localProgress = smoothstep(((progress - localDelay) / 0.82).clamped(to: 0.0 ... 1.0))
        let flourish = flourishPose(for: slot, minuteKey: minuteKey)

        if localProgress < 0.44 {
            let flourishProgress = smoothstep(localProgress / 0.44)
            return previous.interpolated(to: flourish, progress: flourishProgress)
        }

        let settleProgress = ((localProgress - 0.44) / 0.56).clamped(to: 0.0 ... 1.0)
        return settledPose(
            from: flourish,
            to: target,
            progress: settleProgress,
            overshoot: 0.04
        )
    }

    private func flourishPose(for slot: ClockSlot, minuteKey: Int) -> ClockPose {
        let center = ClockSlot.logicalCenter
        let dx = slot.position.x - center.x
        let dy = slot.position.y - center.y
        let baseAngle = atan2(dy, dx) + (.pi / 2.0)
        let directionalBias = Double((minuteKey + slot.digitIndex) % 3 - 1) * 0.05
        let spread = 0.42 + (Double(slot.column) * 0.06)

        return ClockPose(
            hourAngle: baseAngle + directionalBias - spread,
            minuteAngle: baseAngle + directionalBias + spread
        )
    }

    private func settledPose(
        from source: ClockPose,
        to target: ClockPose,
        progress: Double,
        overshoot: Double
    ) -> ClockPose {
        let overshootPose = overshootingPose(from: source, to: target, amount: overshoot)

        if progress < 0.84 {
            let localProgress = smoothstep(progress / 0.84)
            return source.interpolated(to: overshootPose, progress: localProgress)
        }

        let localProgress = smoothstep((progress - 0.84) / 0.16)
        return overshootPose.interpolated(to: target, progress: localProgress)
    }

    private func overshootingPose(
        from source: ClockPose,
        to target: ClockPose,
        amount: Double
    ) -> ClockPose {
        ClockPose(
            hourAngle: target.hourAngle + shortestDelta(from: source.hourAngle, to: target.hourAngle) * amount,
            minuteAngle: target.minuteAngle + shortestDelta(from: source.minuteAngle, to: target.minuteAngle) * amount
        )
    }

    private func slotDistance(from start: LogicalPoint, to end: LogicalPoint) -> Double {
        let dx = end.x - start.x
        let dy = end.y - start.y
        return sqrt((dx * dx) + (dy * dy))
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

    private func smoothstep(_ value: Double) -> Double {
        let clamped = value.clamped(to: 0.0 ... 1.0)
        return clamped * clamped * (3.0 - (2.0 * clamped))
    }
}
