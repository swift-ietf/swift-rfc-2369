// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-rfc-2369",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26)
    ],
    products: [
        .library(
            name: "RFC 2369",
            targets: ["RFC 2369"]
        )
    ],
    dependencies: [
        .package(path: "../../swift-foundations/swift-ascii"),
        .package(path: "../swift-rfc-3987")
    ],
    targets: [
        .target(
            name: "RFC 2369",
            dependencies: [
                .product(name: "ASCII", package: "swift-ascii"),
                .product(name: "RFC 3987", package: "swift-rfc-3987")
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: Self { self + " Tests" }
    var foundation: Self { self + " Foundation" }
}

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableExperimentalFeature("SuppressedAssociatedTypesWithDefaults"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
