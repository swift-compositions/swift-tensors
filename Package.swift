// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-tensors",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "Tensors Operations", targets: ["Tensors Operations"]),
        .library(name: "Tensors", targets: ["Tensors"]),
        .library(name: "Tensors Test Support", targets: ["Tensors Test Support"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-tensor.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-complex.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-numeric.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-vector.git",
            branch: "main"
        ),
        .package(url: "https://github.com/swift-iso/swift-iso-9899.git", branch: "main"),
    ],
    targets: [

        .target(
            name: "Tensors Core",
            dependencies: [
                .product(name: "Tensor", package: "swift-tensor"),
                .product(name: "Complex", package: "swift-complex"),
                .product(name: "Numeric", package: "swift-numeric"),
                .product(name: "Real", package: "swift-numeric"),
                .product(name: "Vector", package: "swift-vector"),
                .product(name: "ISO 9899 Core", package: "swift-iso-9899"),
            ]
        ),

        .target(
            name: "Tensors Operations",
            dependencies: ["Tensors Core"]
        ),

        .target(
            name: "Tensors",
            dependencies: [
                "Tensors Core",
                "Tensors Operations",
            ]
        ),

        .target(
            name: "Tensors Test Support",
            dependencies: [
                "Tensors",
                .product(
                    name: "Tensor Test Support",
                    package: "swift-tensor"
                ),
            ],
            path: "Tests/Support"
        ),

        .testTarget(
            name: "Tensors Tests",
            dependencies: [
                "Tensors",
                "Tensors Test Support",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableExperimentalFeature("Lifetimes"),
    ]

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem
}
