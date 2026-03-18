import A2DClockCore
import SwiftUI

enum ClockHandPlacement: Equatable {
    case centered
    case leading
    case trailing
}

struct ClockHandGeometry {
    private static let straightThreshold = 0.08

    static func placements(
        hourAngle: Double,
        minuteAngle: Double,
        hourVisible: Bool,
        minuteVisible: Bool
    ) -> (hour: ClockHandPlacement, minute: ClockHandPlacement) {
        guard hourVisible, minuteVisible else {
            return (.centered, .centered)
        }

        let delta = clockwiseDelta(from: hourAngle, to: minuteAngle)
        if delta < straightThreshold || abs(delta - (.pi * 2.0)) < straightThreshold || abs(delta - .pi) < straightThreshold {
            return (.centered, .centered)
        }

        if delta < .pi {
            return (.leading, .trailing)
        }

        return (.trailing, .leading)
    }

    static func path(
        center: CGPoint,
        angle: Double,
        radius: CGFloat,
        lineWidth: CGFloat,
        placement: ClockHandPlacement
    ) -> Path {
        let direction = CGPoint(x: sin(angle), y: -cos(angle))
        let endPoint = CGPoint(
            x: center.x + (direction.x * radius),
            y: center.y + (direction.y * radius)
        )

        switch placement {
        case .centered:
            let offset = trailingNormal(for: direction, magnitude: lineWidth * 0.5)
            return quadrilateralPath(
                a: CGPoint(x: center.x - offset.x, y: center.y - offset.y),
                b: CGPoint(x: center.x + offset.x, y: center.y + offset.y),
                c: CGPoint(x: endPoint.x + offset.x, y: endPoint.y + offset.y),
                d: CGPoint(x: endPoint.x - offset.x, y: endPoint.y - offset.y)
            )
        case .leading:
            let offset = leadingNormal(for: direction, magnitude: lineWidth)
            return quadrilateralPath(
                a: center,
                b: CGPoint(x: center.x + offset.x, y: center.y + offset.y),
                c: CGPoint(x: endPoint.x + offset.x, y: endPoint.y + offset.y),
                d: endPoint
            )
        case .trailing:
            let offset = trailingNormal(for: direction, magnitude: lineWidth)
            return quadrilateralPath(
                a: center,
                b: CGPoint(x: center.x + offset.x, y: center.y + offset.y),
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
}

struct ClockFaceView: View {
    let pose: ClockPose
    let theme: ClockTheme

    var body: some View {
        Canvas { context, size in
            let radius = min(size.width, size.height) * 0.5
            let center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
            let lineWidth = radius * 0.2
            let placements = ClockHandGeometry.placements(
                hourAngle: pose.hourAngle,
                minuteAngle: pose.minuteAngle,
                hourVisible: pose.hourOpacity > 0.001,
                minuteVisible: pose.minuteOpacity > 0.001
            )

            drawHand(
                in: &context,
                path: ClockHandGeometry.path(
                    center: center,
                    angle: pose.hourAngle,
                    radius: radius * 0.84,
                    lineWidth: lineWidth,
                    placement: placements.hour
                ),
                color: theme.handColor,
                glowColor: theme.glowColor,
                opacity: pose.hourOpacity
            )

            drawHand(
                in: &context,
                path: ClockHandGeometry.path(
                    center: center,
                    angle: pose.minuteAngle,
                    radius: radius * 0.84,
                    lineWidth: lineWidth,
                    placement: placements.minute
                ),
                color: theme.handColor,
                glowColor: theme.glowColor,
                opacity: pose.minuteOpacity
            )
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
