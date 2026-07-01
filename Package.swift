// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "TimeUI",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
        .tvOS(.v18),
        .macOS(.v12),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "TimeUI",
            targets: ["TimeUI"]
        ),
    ],
    targets: [
        .target(
            name: "TimeUI"
        ),
        .testTarget(
            name: "TimeUITests",
            dependencies: ["TimeUI"]
        ),
    ]
)
