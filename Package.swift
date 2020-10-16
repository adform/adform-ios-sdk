// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdformAdvertising",
    platforms: [
            .iOS(.v9)
        ],
    products: [
        .library(
            name: "AdformAdvertising",
            targets: ["AdformAdvertising"])
    ],
    targets: [
        .binaryTarget(
                    name: "AdformAdvertising",
                    path: "AdformAdvertising.xcframework")
    ]
)
