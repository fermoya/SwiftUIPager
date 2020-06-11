// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIPager",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v10),
        .watchOS(.v4),
        .tvOS(.v10)
    ],
    products: [
        .library(
            name: "SwiftUIPager",
            targets: ["SwiftUIPager"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftUIPager",
            dependencies: []),
        .testTarget(
            name: "SwiftUIPagerTests",
            dependencies: ["SwiftUIPager"]),
    ],
    swiftLanguageVersions: [.v5]
)
