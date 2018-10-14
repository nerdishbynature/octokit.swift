// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OctoKit",

    products: [
        .library(
            name: "OctoKit",
            targets: ["OctoKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/shkhaliq/RequestKit", .branch("support-for-swift4")),
    ],
    targets: [
        .target(
            name: "OctoKit",
            dependencies: ["RequestKit"],
            path: ".",
            sources: ["OctoKit"]),
        .testTarget(
            name: "OctoKitTests",
            dependencies: ["OctoKit"],
            path: "OctoKitTests",
            sources: ["."]),
    ]
)
