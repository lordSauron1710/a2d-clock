import A2DClockCore
import SwiftUI

struct ClockFaceView: View {
    let pose: ClockPose
    let theme: ClockTheme
    let faceFill: Color

    var body: some View {
        Canvas { context, size in
            let rect = CGRect(origin: .zero, size: size)
            let radius = min(size.width, size.height) * 0.5
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let cellRect = rect.insetBy(dx: size.width * 0.008, dy: size.height * 0.008)
            let cellPath = Path(cellRect)

            context.fill(cellPath, with: .color(faceFill))
            context.stroke(cellPath, with: .color(theme.cellStroke), lineWidth: max(1.0, size.width * 0.012))

            drawHand(
                in: &context,
                center: center,
                angle: pose.hourAngle,
                radius: radius * 0.66,
                backRadius: 0,
                lineWidth: radius * 0.12,
                color: theme.handColor
            )

            drawHand(
                in: &context,
                center: center,
                angle: pose.minuteAngle,
                radius: radius * 0.66,
                backRadius: 0,
                lineWidth: radius * 0.12,
                color: theme.handSecondaryColor
            )

            let capRect = CGRect(
                x: center.x - (radius * 0.055),
                y: center.y - (radius * 0.055),
                width: radius * 0.11,
                height: radius * 0.11
            )

            context.fill(Path(ellipseIn: capRect), with: .color(theme.hubColor))
        }
        .shadow(color: theme.shadow.opacity(0.18), radius: 1, x: 0, y: 1)
        .overlay {
            if theme.isNight && theme.handGlow != .clear {
                Rectangle()
                    .stroke(theme.handGlow, lineWidth: 1)
                    .blur(radius: 6)
                    .padding(8)
            }
        }
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
