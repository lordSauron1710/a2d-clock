// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "a2d-clock",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "A2DClock",
            targets: ["A2DClock"]
        )
    ],
    targets: [
        .target(
            name: "A2DClockCore"
        ),
        .executableTarget(
            name: "A2DClock",
            dependencies: ["A2DClockCore"]
        ),
        .testTarget(
            name: "A2DClockCoreTests",
            dependencies: ["A2DClockCore"]
        )
    ]
)
