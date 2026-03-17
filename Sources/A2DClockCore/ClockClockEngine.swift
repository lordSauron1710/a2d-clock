import Foundation

public struct ClockClockFrame: Equatable, Sendable {
    public let digits: [Int]
    public let poses: [ClockPose]

    public init(digits: [Int], poses: [ClockPose]) {
        self.digits = digits
        self.poses = poses
    }
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
        let currentFrame = ClockClockFrame(
            digits: currentDigits,
            poses: currentPoses
        )

        let components = calendar.dateComponents([.second, .nanosecond], from: date)
        let seconds = Double(components.second ?? 0)
        let nanoseconds = Double(components.nanosecond ?? 0)
        let secondsIntoMinute = seconds + (nanoseconds / 1_000_000_000.0)

        guard secondsIntoMinute < transitionDuration else {
            return currentFrame
        }

        let previousDate = date.addingTimeInterval(-60.0)
        let previousDigits = digits(for: previousDate, calendar: calendar)
        let previousFrame = ClockClockFrame(
            digits: previousDigits,
            poses: DigitGlyph.poses(for: previousDigits)
        )
        let minuteKey = Int(floor(date.timeIntervalSinceReferenceDate / 60.0))

        return transitionFrame(
            from: previousFrame,
            to: currentFrame,
            progress: secondsIntoMinute / transitionDuration,
            transitionKey: minuteKey
        )
    }

    public func transitionFrame(
        from previous: ClockClockFrame,
        to target: ClockClockFrame,
        progress: Double,
        transitionKey: Int
    ) -> ClockClockFrame {
        let clampedProgress = progress.clamped(to: 0.0 ... 1.0)
        if clampedProgress == 0.0 {
            return ClockClockFrame(
                digits: target.digits,
                poses: previous.poses
            )
        }

        if clampedProgress == 1.0 {
            return target
        }

        return ClockClockFrame(
            digits: target.digits,
            poses: transitionPoses(
                from: previous.poses,
                to: target.poses,
                progress: smoothstep(clampedProgress),
                minuteKey: transitionKey
            )
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
        let motionPose: ClockPose

        if localProgress < 0.44 {
            let flourishProgress = smoothstep(localProgress / 0.44)
            motionPose = previous.interpolated(to: flourish, progress: flourishProgress)
        } else {
            let settleProgress = ((localProgress - 0.44) / 0.56).clamped(to: 0.0 ... 1.0)
            motionPose = settledPose(
                from: flourish,
                to: target,
                progress: settleProgress
            )
        }

        return motionPose.withVisibility(
            hourOpacity: blendedVisibility(
                from: previous.hourOpacity,
                to: target.hourOpacity,
                progress: localProgress
            ),
            minuteOpacity: blendedVisibility(
                from: previous.minuteOpacity,
                to: target.minuteOpacity,
                progress: localProgress
            )
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
        progress: Double
    ) -> ClockPose {
        source.interpolated(to: target, progress: springyClockwiseProgress(progress))
    }

    private func slotDistance(from start: LogicalPoint, to end: LogicalPoint) -> Double {
        let dx = end.x - start.x
        let dy = end.y - start.y
        return sqrt((dx * dx) + (dy * dy))
    }

    private func smoothstep(_ value: Double) -> Double {
        let clamped = value.clamped(to: 0.0 ... 1.0)
        return clamped * clamped * (3.0 - (2.0 * clamped))
    }

    private func springyClockwiseProgress(_ value: Double) -> Double {
        let clamped = value.clamped(to: 0.0 ... 1.0)
        let overshootAmount = 0.28
        let overshootScale = overshootAmount + 1.0
        let shifted = clamped - 1.0
        return (1.0
            + (overshootScale * pow(shifted, 3.0))
            + (overshootAmount * pow(shifted, 2.0)))
            .clamped(to: 0.0 ... 1.0)
    }

    private func blendedVisibility(
        from source: Double,
        to target: Double,
        progress: Double
    ) -> Double {
        if abs(source - target) < 0.0001 {
            return target
        }

        let clampedProgress = progress.clamped(to: 0.0 ... 1.0)
        if source > target {
            let fadeProgress = smoothstep((clampedProgress / 0.34).clamped(to: 0.0 ... 1.0))
            return source + ((target - source) * fadeProgress)
        }

        let fadeProgress = smoothstep(((clampedProgress - 0.24) / 0.56).clamped(to: 0.0 ... 1.0))
        return source + ((target - source) * fadeProgress)
    }
}
