// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "a2d-clock",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "A2DClockCore",
            type: .static,
            targets: ["A2DClockCore"]
        ),
        .library(
            name: "A2DClockSurface",
            type: .static,
            targets: ["A2DClockSurface"]
        ),
        .executable(
            name: "A2DClock",
            targets: ["A2DClock"]
        )
    ],
    targets: [
        .target(
            name: "A2DClockCore"
        ),
        .target(
            name: "A2DClockSurface",
            dependencies: ["A2DClockCore"]
        ),
        .executableTarget(
            name: "A2DClock",
            dependencies: ["A2DClockSurface"]
        ),
        .testTarget(
            name: "A2DClockCoreTests",
            dependencies: ["A2DClockCore"]
        )
    ]
)
