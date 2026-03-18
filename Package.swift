// swift-tools-version: 6.1

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
        .library(
            name: "A2DClockSaver",
            type: .dynamic,
            targets: ["A2DClockSaver"]
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
        .target(
            name: "A2DClockSaver",
            dependencies: ["A2DClockSurface"]
        ),
        .executableTarget(
            name: "A2DClock",
            dependencies: ["A2DClockSurface"],
            linkerSettings: [
                .linkedFramework("ScreenSaver")
            ]
        ),
        .testTarget(
            name: "A2DClockCoreTests",
            dependencies: ["A2DClockCore"]
        ),
        .testTarget(
            name: "A2DClockSurfaceTests",
            dependencies: ["A2DClockSurface"]
        )
    ]
)
