import A2DClockCore
import SwiftUI

struct ClockFaceView: View {
    let pose: ClockPose
    let theme: ClockTheme

    var body: some View {
        Canvas { context, size in
            let rect = CGRect(origin: .zero, size: size)
            let radius = min(size.width, size.height) * 0.5
            let center = CGPoint(x: rect.midX, y: rect.midY)

            drawHand(
                in: &context,
                center: center,
                angle: pose.hourAngle,
                radius: radius * 0.84,
                lineWidth: radius * 0.19,
                color: theme.handColor,
                opacity: pose.hourOpacity
            )

            drawHand(
                in: &context,
                center: center,
                angle: pose.minuteAngle,
                radius: radius * 0.84,
                lineWidth: radius * 0.19,
                color: theme.handColor,
                opacity: pose.minuteOpacity
            )
        }
    }

    private func drawHand(
        in context: inout GraphicsContext,
        center: CGPoint,
        angle: Double,
        radius: CGFloat,
        lineWidth: CGFloat,
        color: Color,
        opacity: Double
    ) {
        guard opacity > 0.001 else {
            return
        }

        let endPoint = point(from: center, radius: radius, angle: angle)
        let perpendicular = CGPoint(
            x: cos(angle) * (lineWidth / 2.0),
            y: sin(angle) * (lineWidth / 2.0)
        )

        var handPath = Path()
        handPath.move(to: CGPoint(x: center.x - perpendicular.x, y: center.y + perpendicular.y))
        handPath.addLine(to: CGPoint(x: center.x + perpendicular.x, y: center.y - perpendicular.y))
        handPath.addLine(to: CGPoint(x: endPoint.x + perpendicular.x, y: endPoint.y - perpendicular.y))
        handPath.addLine(to: CGPoint(x: endPoint.x - perpendicular.x, y: endPoint.y + perpendicular.y))
        handPath.closeSubpath()

        context.fill(handPath, with: .color(color.opacity(opacity)))
    }

    private func point(from center: CGPoint, radius: CGFloat, angle: Double) -> CGPoint {
        CGPoint(
            x: center.x + (sin(angle) * radius),
            y: center.y - (cos(angle) * radius)
        )
    }
}
