import A2DClockCore
import Foundation

struct ClockFrameTransition: Equatable {
    let source: ClockClockFrame
    let target: ClockClockFrame
    let startDate: Date
    let duration: TimeInterval
    let transitionKey: Int

    init?(
        source: ClockClockFrame,
        target: ClockClockFrame,
        startDate: Date,
        duration: TimeInterval
    ) {
        guard source.poses.count == target.poses.count else {
            return nil
        }

        guard source.poses != target.poses else {
            return nil
        }

        self.source = source
        self.target = target
        self.startDate = startDate
        self.duration = duration
        self.transitionKey = Int(startDate.timeIntervalSinceReferenceDate * 1000.0)
    }

    func frame(at date: Date, engine: ClockClockEngine) -> ClockClockFrame {
        let elapsed = date.timeIntervalSince(startDate)
        if elapsed <= 0 {
            return source
        }

        if elapsed >= duration {
            return target
        }

        return engine.transitionFrame(
            from: source,
            to: target,
            progress: elapsed / duration,
            transitionKey: transitionKey
        )
    }

    func isActive(at date: Date) -> Bool {
        date.timeIntervalSince(startDate) < duration
    }
}
