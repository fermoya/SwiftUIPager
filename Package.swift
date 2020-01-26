// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIPager",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13)
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
