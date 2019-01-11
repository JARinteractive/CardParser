// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "CardParser",
    products: [
        .library(name: "CardParser", targets: ["CardParser"]),
    ],
    targets: [
        .target(
            name: "CardParser",
            dependencies: []),
        .testTarget(
            name: "CardParserTests",
            dependencies: ["CardParser"]),
    ]
)
