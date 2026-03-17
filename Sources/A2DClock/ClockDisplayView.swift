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

            ZStack {
                Rectangle()
                    .fill(theme.frameColor)
                    .frame(width: layout.outerSize.width, height: layout.outerSize.height)
                    .shadow(color: theme.shadow, radius: 18, x: 0, y: 10)

                Rectangle()
                    .fill(theme.boardFill)
                    .frame(width: layout.innerBoardSize.width, height: layout.innerBoardSize.height)

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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

private struct ClockDisplayLayout {
    let size: CGSize
    let scaleOption: ClockScaleOption

    private let columns: CGFloat = 12
    private let rows: CGFloat = 2

    var cellSize: CGFloat {
        let availableWidth = size.width * scaleOption.widthFactor
        let availableHeight = size.height * scaleOption.heightFactor
        return min(availableWidth / columns, availableHeight / rows) * scaleOption.faceScale
    }

    var frameThickness: CGFloat {
        max(10, cellSize * 0.12)
    }

    var boardInset: CGFloat {
        max(6, cellSize * 0.08)
    }

    var innerBoardSize: CGSize {
        CGSize(width: columns * cellSize, height: rows * cellSize)
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

    func position(for slot: ClockSlot) -> CGPoint {
        let globalColumn = (slot.digitIndex * 3) + slot.column

        return CGPoint(
            x: boardOrigin.x + (CGFloat(globalColumn) * cellSize) + (cellSize / 2.0),
            y: boardOrigin.y + (CGFloat(slot.row) * cellSize) + (cellSize / 2.0)
        )
    }
}
