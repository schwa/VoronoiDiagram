// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "Geometry",
    platforms: [
        .macOS("15.4"),
    ],
    products: [
        .library(name: "Geometry", targets: ["Geometry"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-numerics", from: "1.0.0"),
        .package(url: "https://github.com/schwa/SwiftFormats", from: "0.0.1"),
    ],
    targets: [
        .target(
            name: "Geometry",
            dependencies: [
                .product(name: "Numerics", package: "swift-numerics"),
                .product(name: "SwiftFormats", package: "SwiftFormats"),
            ]
        ),
        .testTarget(name: "GeometryTests", dependencies: ["Geometry"]
        ),
    ]
)
