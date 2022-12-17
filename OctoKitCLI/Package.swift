// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "OctoKitCLI",
                      dependencies: [
                          .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
                          .package(url: "https://github.com/onevcat/Rainbow", from: "4.0.0"),
                          .package(path: "../")
                      ],
                      targets: [
                          // Targets are the basic building blocks of a package. A target can define a module or a test suite.
                          // Targets can depend on other targets in this package, and on products in packages this package depends on.
                          .executableTarget(name: "OctoKitCLI",
                                            dependencies: [
                                                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                                                .product(name: "OctoKit", package: "octokit.swift"),
                                                .product(name: "Rainbow", package: "rainbow")
                                            ])
                      ])
