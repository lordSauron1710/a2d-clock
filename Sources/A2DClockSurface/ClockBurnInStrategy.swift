import Foundation
import SwiftUI

struct ClockBurnInTransform {
    let xOffset: CGFloat
    let yOffset: CGFloat
    let rotationDegrees: Double
    let scale: CGFloat
}

enum ClockBurnInStrategy {
    private static let anchorWindow: TimeInterval = 9 * 60
    private static let blendDuration: TimeInterval = 18

    static func transform(
        for date: Date,
        viewportSize: CGSize,
        boardSize: CGSize
    ) -> ClockBurnInTransform {
        let anchorIndex = Int(floor(date.timeIntervalSinceReferenceDate / anchorWindow))
        let segmentProgress = date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: anchorWindow)
        let blendProgress = min(1.0, segmentProgress / blendDuration)

        let previousAnchor = anchorTransform(
            for: anchorIndex - 1,
            viewportSize: viewportSize,
            boardSize: boardSize
        )
        let currentAnchor = anchorTransform(
            for: anchorIndex,
            viewportSize: viewportSize,
            boardSize: boardSize
        )

        return interpolate(from: previousAnchor, to: currentAnchor, progress: smoothstep(blendProgress))
    }

    private static func anchorTransform(
        for key: Int,
        viewportSize: CGSize,
        boardSize: CGSize
    ) -> ClockBurnInTransform {
        let horizontalTravel = max(0, (viewportSize.width - boardSize.width) * 0.22)
        let verticalTravel = max(0, (viewportSize.height - boardSize.height) * 0.22)
        let xRange = min(24.0, horizontalTravel)
        let yRange = min(18.0, verticalTravel)

        return ClockBurnInTransform(
            xOffset: CGFloat(centeredNoise(seed: key * 17 + 3) * xRange),
            yOffset: CGFloat(centeredNoise(seed: key * 29 + 7) * yRange),
            rotationDegrees: centeredNoise(seed: key * 43 + 11) * 0.55,
            scale: 1.0 + CGFloat(centeredNoise(seed: key * 61 + 13) * 0.008)
        )
    }

    private static func interpolate(
        from start: ClockBurnInTransform,
        to end: ClockBurnInTransform,
        progress: Double
    ) -> ClockBurnInTransform {
        let t = CGFloat(progress)

        return ClockBurnInTransform(
            xOffset: start.xOffset + ((end.xOffset - start.xOffset) * t),
            yOffset: start.yOffset + ((end.yOffset - start.yOffset) * t),
            rotationDegrees: start.rotationDegrees + ((end.rotationDegrees - start.rotationDegrees) * progress),
            scale: start.scale + ((end.scale - start.scale) * t)
        )
    }

    private static func centeredNoise(seed: Int) -> Double {
        sin(Double(seed) * 12.9898) * 0.5
    }

    private static func smoothstep(_ value: Double) -> Double {
        let clamped = min(max(value, 0.0), 1.0)
        return clamped * clamped * (3.0 - (2.0 * clamped))
    }
}
