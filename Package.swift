// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-p12",
    products: [
        .library(
            name: "SwiftP12",
            targets: ["SwiftP12"]
        )
    ],
    targets: [
        .target(
            name: "SwiftP12",
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),
        .testTarget(
            name: "SwiftP12Tests",
            dependencies: [
                .target(name: "SwiftP12")
            ],
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        )
    ]
)
