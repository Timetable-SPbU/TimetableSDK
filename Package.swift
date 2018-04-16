// swift-tools-version:4.1

import PackageDescription

let package = Package(
    name: "TimetableSDK",
    products: [
        .library(name: "TimetableSDK", targets: ["TimetableSDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/broadwaylamb/Hammond.git",
                 .branchItem("master")),

        // For testing the requests.
        .package(url: "https://github.com/dmcyk/SwiftyCurl.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "TimetableSDK",
            dependencies: ["Hammond"]),
        .testTarget(
            name: "TimetableSDKTests",
            dependencies: ["TimetableSDK", "SwiftyCurl"]),
    ]
)
