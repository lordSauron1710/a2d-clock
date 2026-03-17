import A2DClockCore
import SwiftUI

struct ClockDisplayView: View {
    let frame: ClockClockFrame
    let theme: ClockTheme
    let date: Date
    let scaleOption: ClockScaleOption

    var body: some View {
        GeometryReader { proxy in
            let layout = ClockDisplayLayout(size: proxy.size, scaleOption: scaleOption)
            let burnInTransform = ClockBurnInStrategy.transform(
                for: date,
                viewportSize: proxy.size,
                boardSize: layout.outerSize
            )

            ZStack {
                Rectangle()
                    .fill(theme.frameColor)
                    .frame(width: layout.outerSize.width, height: layout.outerSize.height)
                    .shadow(color: theme.shadow, radius: 18, x: 0, y: 10)

                Rectangle()
                    .fill(theme.boardFill)
                    .frame(width: layout.innerBoardSize.width, height: layout.innerBoardSize.height)

                ForEach(Array(layout.separatorCenters.enumerated()), id: \.offset) { _, point in
                    Circle()
                        .fill(theme.separator.opacity(frame.colonVisible ? 1.0 : 0.2))
                        .frame(width: layout.separatorSize, height: layout.separatorSize)
                        .position(point)
                }

                ForEach(ClockSlot.all) { slot in
                    ClockFaceView(
                        pose: frame.poses[slot.id],
                        theme: theme,
                        faceFill: theme.faceFill(for: slot.digitIndex)
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

private struct ClockDisplayLayout {
    let size: CGSize
    let scaleOption: ClockScaleOption

    private let logicalWidth = CGFloat(ClockSlot.layoutWidth)
    private let logicalHeight = CGFloat(ClockSlot.layoutHeight)
    private let logicalMinX = CGFloat(ClockSlot.all.map(\.position.x).min() ?? 0.0)
    private let logicalMinY = CGFloat(ClockSlot.all.map(\.position.y).min() ?? 0.0)

    var cellSize: CGFloat {
        let availableWidth = size.width * scaleOption.widthFactor
        let availableHeight = size.height * scaleOption.heightFactor
        return min(availableWidth / logicalWidth, availableHeight / logicalHeight) * scaleOption.faceScale
    }

    var frameThickness: CGFloat {
        max(10, cellSize * 0.12)
    }

    var boardInset: CGFloat {
        max(6, cellSize * 0.08)
    }

    var separatorSize: CGFloat {
        max(6, cellSize * 0.18)
    }

    var innerBoardSize: CGSize {
        CGSize(width: logicalWidth * cellSize, height: logicalHeight * cellSize)
    }

    var outerSize: CGSize {
        CGSize(
            width: innerBoardSize.width + (frameThickness * 2) + (boardInset * 2),
            height: innerBoardSize.height + (frameThickness * 2) + (boardInset * 2)
        )
    }

    private var outerOrigin: CGPoint {
        CGPoint(
            x: (size.width - outerSize.width) / 2.0,
            y: (size.height - outerSize.height) / 2.0
        )
    }

    private var boardOrigin: CGPoint {
        CGPoint(
            x: outerOrigin.x + frameThickness + boardInset,
            y: outerOrigin.y + frameThickness + boardInset
        )
    }

    var separatorCenters: [CGPoint] {
        let leadingEdge = CGFloat(ClockSlot.all.filter { $0.digitIndex == 1 }.map(\.position.x).max() ?? 0.0) + 1.0
        let trailingEdge = CGFloat(ClockSlot.all.filter { $0.digitIndex == 2 }.map(\.position.x).min() ?? 0.0)
        let separatorX = boardOrigin.x + (((leadingEdge + trailingEdge) / 2.0) - logicalMinX) * cellSize

        return [
            CGPoint(x: separatorX, y: boardOrigin.y + (cellSize * 0.72)),
            CGPoint(x: separatorX, y: boardOrigin.y + (cellSize * 1.28))
        ]
    }

    func position(for slot: ClockSlot) -> CGPoint {
        CGPoint(
            x: boardOrigin.x + (CGFloat(slot.position.x) - logicalMinX) * cellSize + (cellSize / 2.0),
            y: boardOrigin.y + (CGFloat(slot.position.y) - logicalMinY) * cellSize + (cellSize / 2.0)
        )
    }
}
