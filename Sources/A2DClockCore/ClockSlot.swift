import Foundation

public struct LogicalPoint: Equatable, Sendable {
    public let x: Double
    public let y: Double

    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

public struct ClockSlot: Identifiable, Equatable, Sendable {
    public let id: Int
    public let digitIndex: Int
    public let localIndex: Int
    public let row: Int
    public let column: Int
    public let position: LogicalPoint

    public static let digitColumns = 2
    public static let digitRows = 3
    public static let standardGap = 0.72
    public static let centerGap = 1.28

    public static let all: [ClockSlot] = {
        let localCoordinates: [(row: Int, column: Int)] = [
            (0, 0), (0, 1),
            (1, 0), (1, 1),
            (2, 0), (2, 1)
        ]

        return (0 ..< 4).flatMap { digitIndex in
            let baseX = xOffset(for: digitIndex)
            return localCoordinates.enumerated().map { localIndex, coordinate in
                ClockSlot(
                    id: digitIndex * 6 + localIndex,
                    digitIndex: digitIndex,
                    localIndex: localIndex,
                    row: coordinate.row,
                    column: coordinate.column,
                    position: LogicalPoint(
                        x: baseX + Double(coordinate.column),
                        y: Double(coordinate.row)
                    )
                )
            }
        }
    }()

    public static var layoutWidth: Double {
        guard let minX = all.map(\.position.x).min(),
              let maxX = all.map(\.position.x).max() else {
            return 0.0
        }

        return (maxX - minX) + 1.0
    }

    public static var layoutHeight: Double {
        Double(digitRows)
    }

    public static var logicalCenter: LogicalPoint {
        guard let minX = all.map(\.position.x).min(),
              let maxX = all.map(\.position.x).max(),
              let minY = all.map(\.position.y).min(),
              let maxY = all.map(\.position.y).max() else {
            return LogicalPoint(x: 0.0, y: 0.0)
        }

        return LogicalPoint(
            x: (minX + maxX) / 2.0,
            y: (minY + maxY) / 2.0
        )
    }

    private static func xOffset(for digitIndex: Int) -> Double {
        let digitWidth = Double(digitColumns)
        return (Double(digitIndex) * (digitWidth + standardGap)) + (digitIndex >= 2 ? centerGap : 0.0)
    }
}
