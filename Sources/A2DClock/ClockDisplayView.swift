import A2DClockCore
import SwiftUI

struct ClockDisplayView: View {
    let frame: ClockClockFrame
    let theme: BauhausTheme
    let date: Date

    var body: some View {
        GeometryReader { proxy in
            let layout = ClockDisplayLayout(size: proxy.size)
            let drift = layout.driftOffset(for: date)

            ZStack {
                ForEach(ClockSlot.all) { slot in
                    ClockFaceView(
                        pose: frame.poses[slot.id],
                        theme: theme,
                        faceFill: theme.faceFill(for: slot.digitIndex)
                    )
                    .frame(width: layout.faceDiameter, height: layout.faceDiameter)
                    .position(layout.position(for: slot))
                }

                SeparatorDotsView(
                    layout: layout,
                    theme: theme,
                    visible: frame.colonVisible
                )
            }
            .offset(drift)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

private struct ClockDisplayLayout {
    let size: CGSize

    private let widthFactor: CGFloat = 0.83
    private let heightFactor: CGFloat = 0.40

    var unitSize: CGFloat {
        min(
            (size.width * widthFactor) / CGFloat(ClockSlot.layoutWidth),
            (size.height * heightFactor) / CGFloat(ClockSlot.layoutHeight)
        )
    }

    var faceDiameter: CGFloat {
        unitSize * 0.88
    }

    func position(for slot: ClockSlot) -> CGPoint {
        let center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        return CGPoint(
            x: center.x + CGFloat(slot.position.x - ClockSlot.logicalCenter.x) * unitSize,
            y: center.y + CGFloat(slot.position.y - ClockSlot.logicalCenter.y) * unitSize
        )
    }

    func driftOffset(for date: Date) -> CGSize {
        let time = date.timeIntervalSinceReferenceDate
        return CGSize(
            width: CGFloat((sin(time / 79.0) * 12.0) + (cos(time / 121.0) * 7.0)),
            height: CGFloat((cos(time / 89.0) * 8.0) + (sin(time / 143.0) * 5.0))
        )
    }

    var separatorTop: CGPoint {
        CGPoint(x: size.width / 2.0, y: (size.height / 2.0) - (unitSize * 0.36))
    }

    var separatorBottom: CGPoint {
        CGPoint(x: size.width / 2.0, y: (size.height / 2.0) + (unitSize * 0.36))
    }

    var separatorSize: CGFloat {
        unitSize * 0.16
    }
}

private struct SeparatorDotsView: View {
    let layout: ClockDisplayLayout
    let theme: BauhausTheme
    let visible: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(theme.separator.opacity(visible ? 0.95 : 0.18))
                .frame(width: layout.separatorSize, height: layout.separatorSize)
                .position(layout.separatorTop)

            Circle()
                .fill(theme.separator.opacity(visible ? 0.95 : 0.18))
                .frame(width: layout.separatorSize, height: layout.separatorSize)
                .position(layout.separatorBottom)
        }
        .shadow(color: theme.separator.opacity(0.22), radius: 10, x: 0, y: 2)
        .animation(.easeInOut(duration: 0.3), value: visible)
    }
}
