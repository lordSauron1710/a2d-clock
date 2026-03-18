import A2DClockCore
import SwiftUI

enum ClockHandPlacement: Equatable {
    case centered
    case leading
    case trailing
}

struct ClockHandGeometry {
    private static let seamOverlapMultiplier: CGFloat = 1.02
    private static let junctionOverlapMultiplier: CGFloat = 0.35
    private static let visibilityThreshold = 0.001
    private static let coincidentThreshold = 0.02

    static func placements(
        hourAngle: Double,
        minuteAngle: Double,
        hourVisible: Bool,
        minuteVisible: Bool
    ) -> (hour: ClockHandPlacement, minute: ClockHandPlacement) {
        guard hourVisible || minuteVisible else {
            return (.centered, .centered)
        }

        return (.centered, .centered)
    }

    static func handReach(for faceRadius: CGFloat) -> CGFloat {
        faceRadius * seamOverlapMultiplier
    }

    static func coincidentOpacity(
        hourAngle: Double,
        minuteAngle: Double,
        hourOpacity: Double,
        minuteOpacity: Double
    ) -> Double? {
        guard hourOpacity > visibilityThreshold, minuteOpacity > visibilityThreshold else {
            return nil
        }

        guard angularDistance(from: hourAngle, to: minuteAngle) < coincidentThreshold else {
            return nil
        }

        return 1.0 - ((1.0 - hourOpacity) * (1.0 - minuteOpacity))
    }

    static func path(
        center: CGPoint,
        angle: Double,
        radius: CGFloat,
        lineWidth: CGFloat,
        placement: ClockHandPlacement
    ) -> Path {
        let direction = CGPoint(x: sin(angle), y: -cos(angle))
        let startPoint = CGPoint(
            x: center.x - (direction.x * junctionOverlap(for: lineWidth)),
            y: center.y - (direction.y * junctionOverlap(for: lineWidth))
        )
        let endPoint = CGPoint(
            x: center.x + (direction.x * radius),
            y: center.y + (direction.y * radius)
        )

        switch placement {
        case .centered:
            let offset = trailingNormal(for: direction, magnitude: lineWidth * 0.5)
            return quadrilateralPath(
                a: CGPoint(x: startPoint.x - offset.x, y: startPoint.y - offset.y),
                b: CGPoint(x: startPoint.x + offset.x, y: startPoint.y + offset.y),
                c: CGPoint(x: endPoint.x + offset.x, y: endPoint.y + offset.y),
                d: CGPoint(x: endPoint.x - offset.x, y: endPoint.y - offset.y)
            )
        case .leading:
            let offset = leadingNormal(for: direction, magnitude: lineWidth)
            return quadrilateralPath(
                a: startPoint,
                b: CGPoint(x: startPoint.x + offset.x, y: startPoint.y + offset.y),
                c: CGPoint(x: endPoint.x + offset.x, y: endPoint.y + offset.y),
                d: endPoint
            )
        case .trailing:
            let offset = trailingNormal(for: direction, magnitude: lineWidth)
            return quadrilateralPath(
                a: startPoint,
                b: CGPoint(x: startPoint.x + offset.x, y: startPoint.y + offset.y),
                c: CGPoint(x: endPoint.x + offset.x, y: endPoint.y + offset.y),
                d: endPoint
            )
        }
    }

    private static func quadrilateralPath(
        a: CGPoint,
        b: CGPoint,
        c: CGPoint,
        d: CGPoint
    ) -> Path {
        var path = Path()
        path.move(to: a)
        path.addLine(to: b)
        path.addLine(to: c)
        path.addLine(to: d)
        path.closeSubpath()
        return path
    }

    private static func leadingNormal(for direction: CGPoint, magnitude: CGFloat) -> CGPoint {
        CGPoint(
            x: direction.y * magnitude,
            y: -direction.x * magnitude
        )
    }

    private static func trailingNormal(for direction: CGPoint, magnitude: CGFloat) -> CGPoint {
        CGPoint(
            x: -direction.y * magnitude,
            y: direction.x * magnitude
        )
    }

    private static func junctionOverlap(for lineWidth: CGFloat) -> CGFloat {
        lineWidth * junctionOverlapMultiplier
    }

    private static func clockwiseDelta(from start: Double, to end: Double) -> Double {
        let turn = Double.pi * 2.0
        let normalizedStart = ClockPose.normalize(start)
        let normalizedEnd = ClockPose.normalize(end)
        var delta = normalizedEnd - normalizedStart
        if delta < 0 {
            delta += turn
        }
        return delta
    }

    private static func angularDistance(from start: Double, to end: Double) -> Double {
        let delta = clockwiseDelta(from: start, to: end)
        return min(delta, (Double.pi * 2.0) - delta)
    }
}

struct ClockFaceView: View {
    let pose: ClockPose
    let theme: ClockTheme

    var body: some View {
        Canvas { context, size in
            let faceRadius = min(size.width, size.height) * 0.5
            let center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
            let lineWidth = faceRadius * 0.2
            let handReach = ClockHandGeometry.handReach(for: faceRadius)
            let placements = ClockHandGeometry.placements(
                hourAngle: pose.hourAngle,
                minuteAngle: pose.minuteAngle,
                hourVisible: pose.hourOpacity > 0.001,
                minuteVisible: pose.minuteOpacity > 0.001
            )
            let coincidentOpacity = ClockHandGeometry.coincidentOpacity(
                hourAngle: pose.hourAngle,
                minuteAngle: pose.minuteAngle,
                hourOpacity: pose.hourOpacity,
                minuteOpacity: pose.minuteOpacity
            )

            drawHand(
                in: &context,
                path: ClockHandGeometry.path(
                    center: center,
                    angle: pose.hourAngle,
                    radius: handReach,
                    lineWidth: lineWidth,
                    placement: placements.hour
                ),
                color: theme.handColor,
                glowColor: theme.glowColor,
                opacity: coincidentOpacity ?? pose.hourOpacity
            )

            if coincidentOpacity == nil {
                drawHand(
                    in: &context,
                    path: ClockHandGeometry.path(
                        center: center,
                        angle: pose.minuteAngle,
                        radius: handReach,
                        lineWidth: lineWidth,
                        placement: placements.minute
                    ),
                    color: theme.handColor,
                    glowColor: theme.glowColor,
                    opacity: pose.minuteOpacity
                )
            }
        }
    }

    private func drawHand(
        in context: inout GraphicsContext,
        path: Path,
        color: Color,
        glowColor: Color,
        opacity: Double
    ) {
        guard opacity > 0.001 else {
            return
        }

        if theme.isNight {
            context.drawLayer { layer in
                layer.addFilter(.blur(radius: 4.5))
                layer.fill(path, with: .color(glowColor.opacity(opacity)))
            }
        }

        context.fill(path, with: .color(color.opacity(opacity)))
    }
}
