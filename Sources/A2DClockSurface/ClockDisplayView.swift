import A2DClockCore
import SwiftUI

struct ClockDisplayView: View {
    let frame: ClockClockFrame
    let theme: ClockTheme
    let date: Date
    let clockScale: Double

    var body: some View {
        GeometryReader { proxy in
            let layout = ClockDisplayLayout(size: proxy.size, clockScale: clockScale)
            let burnInTransform = ClockBurnInStrategy.transform(
                for: date,
                viewportSize: proxy.size,
                boardSize: layout.contentSize
            )

            ZStack {
                ForEach(ClockSlot.all) { slot in
                    ClockFaceView(
                        pose: frame.poses[slot.id],
                        theme: theme
                    )
                    .frame(width: layout.cellSize, height: layout.cellSize)
                    .position(layout.position(for: slot))
                }
            }
            .offset(x: burnInTransform.xOffset, y: burnInTransform.yOffset)
            .rotationEffect(.degrees(burnInTransform.rotationDegrees))
            .scaleEffect(burnInTransform.scale)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct ClockDisplayLayout {
    let size: CGSize
    let clockScale: Double

    private let logicalWidth = CGFloat(ClockSlot.layoutWidth)
    private let logicalHeight = CGFloat(ClockSlot.layoutHeight)
    private let logicalMinX = CGFloat(ClockSlot.all.map(\.position.x).min() ?? 0.0)
    private let logicalMinY = CGFloat(ClockSlot.all.map(\.position.y).min() ?? 0.0)

    private var clampedScale: CGFloat {
        let clampedScale = CGFloat(clockScale.clamped(to: ClockCustomizationStore.clockScaleRange))
        return clampedScale
    }

    var cellSize: CGFloat {
        let maxScale = CGFloat(ClockCustomizationStore.clockScaleRange.upperBound)
        let widthLimited = (size.width * 0.985) / (logicalWidth * maxScale)
        let heightLimited = (size.height * 0.82) / (logicalHeight * maxScale)
        return min(widthLimited, heightLimited) * clampedScale
    }

    var contentSize: CGSize {
        CGSize(width: logicalWidth * cellSize, height: logicalHeight * cellSize)
    }

    private var contentOrigin: CGPoint {
        CGPoint(
            x: (size.width - contentSize.width) / 2.0,
            y: (size.height - contentSize.height) / 2.0
        )
    }

    func position(for slot: ClockSlot) -> CGPoint {
        CGPoint(
            x: contentOrigin.x + (CGFloat(slot.position.x) - logicalMinX) * cellSize + (cellSize / 2.0),
            y: contentOrigin.y + (CGFloat(slot.position.y) - logicalMinY) * cellSize + (cellSize / 2.0)
        )
    }
}
