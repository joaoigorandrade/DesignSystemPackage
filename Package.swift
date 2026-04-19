// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [
        .iOS(.v26),
        .macOS(.v15)
    ],
    products: [
        .library(name: "DesignSystem", targets: ["DesignSystem"])
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.0.0")
    ],
    targets: [
        .target(
            name: "DesignSystem",
            dependencies: [
                .product(name: "Kingfisher", package: "Kingfisher")
            ],
            resources: [
                .process("Resources"),
                .copy("Theme/DesignTokenReference.md")
            ]
        ),
        .testTarget(
            name: "DesignSystemTests",
            dependencies: ["DesignSystem"]
        )
    ]
)
