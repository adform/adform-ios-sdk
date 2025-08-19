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
            targets: ["AdformAdvertising"]),
        .library(
            name: "AdformAdmobMediation",
            targets: ["AdformAdmobMediation"]),
    ],
    dependencies: [
        .package(
            name: "GoogleMobileAds",
            url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git",
            from: "12.7.0"
        )
    ],
    targets: [
        .binaryTarget(
            name: "AdformAdvertising",
            path: "AdformAdvertising.xcframework"),
        .target(
            name: "AdformAdmobMediation",
            dependencies: [
                "AdformAdvertising",
                .product(name: "GoogleMobileAds", package: "GoogleMobileAds")
            ],
            path: "AdformAdmobMediation"
        )
    ]
)
