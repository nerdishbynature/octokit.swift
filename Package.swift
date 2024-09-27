// swift-tools-version:5.6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OctoKit",

    products: [
        .library(
            name: "OctoKit",
            targets: ["OctoKit"]
        ),
    ],
    dependencies: [
        .package(name: "RequestKit", path: "../RequestKit"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.52.8")
    ],
    targets: [
        .target(
            name: "OctoKit",
            dependencies: ["RequestKit"],
            path: "OctoKit"
        ),
        .testTarget(
            name: "OctoKitTests",
            dependencies: ["OctoKit"]
        ),
    ]
)
