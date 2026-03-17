import A2DClockCore
import SwiftUI

struct ClockFaceView: View {
    let pose: ClockPose
    let theme: BauhausTheme
    let faceFill: Color

    var body: some View {
        Canvas { context, size in
            let rect = CGRect(origin: .zero, size: size)
            let radius = min(size.width, size.height) * 0.5
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let facePath = Path(ellipseIn: rect.insetBy(dx: radius * 0.05, dy: radius * 0.05))

            context.fill(
                facePath,
                with: .radialGradient(
                    Gradient(colors: [faceFill.opacity(0.98), faceFill.opacity(0.7)]),
                    center: center,
                    startRadius: radius * 0.12,
                    endRadius: radius * 1.02
                )
            )

            context.stroke(
                facePath,
                with: .color(theme.faceRim),
                lineWidth: radius * 0.06
            )

            let glossRect = CGRect(
                x: rect.minX + radius * 0.28,
                y: rect.minY + radius * 0.18,
                width: radius * 0.92,
                height: radius * 0.52
            )
            context.fill(Path(ellipseIn: glossRect), with: .color(theme.faceGloss))

            for tickIndex in 0 ..< 60 {
                let angle = (Double(tickIndex) / 60.0) * (.pi * 2.0)
                let isMajor = tickIndex.isMultiple(of: 5)
                let innerRadius = radius * (isMajor ? 0.63 : 0.76)
                let outerRadius = radius * 0.86

                var path = Path()
                path.move(to: point(from: center, radius: innerRadius, angle: angle))
                path.addLine(to: point(from: center, radius: outerRadius, angle: angle))

                context.stroke(
                    path,
                    with: .color(isMajor ? theme.majorTick : theme.minorTick),
                    lineWidth: radius * (isMajor ? 0.05 : 0.018)
                )
            }

            drawHand(
                in: &context,
                center: center,
                angle: pose.hourAngle,
                radius: radius * 0.48,
                backRadius: radius * 0.14,
                lineWidth: radius * 0.08,
                color: theme.hourHand
            )

            drawHand(
                in: &context,
                center: center,
                angle: pose.minuteAngle,
                radius: radius * 0.77,
                backRadius: radius * 0.14,
                lineWidth: radius * 0.056,
                color: theme.minuteHand
            )

            let capRect = CGRect(
                x: center.x - (radius * 0.12),
                y: center.y - (radius * 0.12),
                width: radius * 0.24,
                height: radius * 0.24
            )

            context.fill(Path(ellipseIn: capRect), with: .color(theme.centerCap))
        }
        .shadow(color: theme.shadow, radius: 16, x: 0, y: 8)
    }

    private func drawHand(
        in context: inout GraphicsContext,
        center: CGPoint,
        angle: Double,
        radius: CGFloat,
        backRadius: CGFloat,
        lineWidth: CGFloat,
        color: Color
    ) {
        var handPath = Path()
        handPath.move(to: point(from: center, radius: backRadius, angle: angle + .pi))
        handPath.addLine(to: point(from: center, radius: radius, angle: angle))

        context.stroke(
            handPath,
            with: .color(color),
            style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
        )
    }

    private func point(from center: CGPoint, radius: CGFloat, angle: Double) -> CGPoint {
        CGPoint(
            x: center.x + (sin(angle) * radius),
            y: center.y - (cos(angle) * radius)
        )
    }
}
