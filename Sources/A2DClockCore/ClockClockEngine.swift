import Foundation

public struct ClockClockFrame: Equatable, Sendable {
    public let digits: [Int]
    public let poses: [ClockPose]
    public let colonVisible: Bool
}

public struct ClockClockEngine: Sendable {
    public var transitionDuration: Double
    public var flourishSplit: Double
    public var transitionStyle: ClockTransitionStyle

    public init(
        transitionDuration: Double = 2.4,
        flourishSplit: Double = 0.34,
        transitionStyle: ClockTransitionStyle = .sweep
    ) {
        self.transitionDuration = transitionDuration
        self.flourishSplit = flourishSplit
        self.transitionStyle = transitionStyle
    }

    public func digits(
        for date: Date,
        calendar: Calendar = .autoupdatingCurrent
    ) -> [Int] {
        let components = calendar.dateComponents([.hour, .minute], from: date)
        let hour = components.hour ?? 0
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
            switch transitionStyle {
            case .step:
                return steppedPose(
                    from: previous[index],
                    to: target[index],
                    slot: slot,
                    progress: progress
                )
            case .sweep:
                let flourish = flourishPose(for: slot, minuteKey: minuteKey)
                if progress < flourishSplit {
                    let localProgress = smoothstep(progress / flourishSplit)
                    return previous[index].interpolated(to: flourish, progress: localProgress)
                }

                let localProgress = smoothstep((progress - flourishSplit) / (1.0 - flourishSplit))
                return flourish.interpolated(to: target[index], progress: localProgress)
            case .glide:
                return glidingPose(
                    from: previous[index],
                    to: target[index],
                    slot: slot,
                    progress: progress
                )
            }
        }
    }

    private func flourishPose(for slot: ClockSlot, minuteKey: Int) -> ClockPose {
        let center = ClockSlot.logicalCenter
        let dx = slot.position.x - center.x
        let dy = slot.position.y - center.y
        let baseAngle = atan2(dy, dx) + (.pi / 2.0)
        let seed = Double((minuteKey * 19) + (slot.id * 7))
        let jitter = sin(seed) * 0.28
        let spread = (.pi / 2.4) + (Double(slot.localIndex % 3) * 0.12)

        return ClockPose(
            hourAngle: baseAngle + jitter - spread,
            minuteAngle: baseAngle + jitter + spread
        )
    }

    private func smoothstep(_ value: Double) -> Double {
        let clamped = value.clamped(to: 0.0 ... 1.0)
        return clamped * clamped * (3.0 - (2.0 * clamped))
    }

    private func steppedPose(
        from previous: ClockPose,
        to target: ClockPose,
        slot: ClockSlot,
        progress: Double
    ) -> ClockPose {
        let groupDelay = (Double(slot.row) * 0.1) + (Double(slot.digitIndex) * 0.035)
        let localProgress = ((progress - groupDelay) / 0.58).clamped(to: 0.0 ... 1.0)
        let steppedProgress = floor(localProgress * 4.0) / 4.0
        return previous.interpolated(to: target, progress: smoothstep(steppedProgress))
    }

    private func glidingPose(
        from previous: ClockPose,
        to target: ClockPose,
        slot: ClockSlot,
        progress: Double
    ) -> ClockPose {
        let center = ClockSlot.logicalCenter
        let dx = slot.position.x - center.x
        let dy = slot.position.y - center.y
        let distance = sqrt((dx * dx) + (dy * dy))
        let delay = distance * 0.028
        let localProgress = smoothstep(((progress - delay) / 0.84).clamped(to: 0.0 ... 1.0))
        return previous.interpolated(to: target, progress: localProgress)
    }
}
