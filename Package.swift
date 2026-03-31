// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [.iOS(.v26)],
    products: [
        .library(name: "DesignSystem", targets: ["DesignSystem"])
    ],
    dependencies: [
        .package(url: "https://github.com/kaishin/Gifu.git", from: "4.0.1"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.3.0")
    ],
    targets: [
        .target(
            name: "DesignSystem",
            dependencies: [
                .product(name: "Gifu", package: "Gifu"),
                .product(name: "Kingfisher", package: "Kingfisher")
            ],
            exclude: ["Components/FABView.md", "Components/DSSwitch.md", "Components/DSLoadingScreen.md", "Components/DSGIFView.md"],
            resources: [.process("Resources")]
        )
    ]
)
