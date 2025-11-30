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
    dependencies: [
        .package(url: "https://github.com/apple/swift-asn1", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .target(
            name: "SwiftP12",
            dependencies: [
                .product(name: "SwiftASN1", package: "swift-asn1")
            ],
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
