// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyBandikaCL",
    defaultLocalization: "en",
    platforms: [.macOS(.v10_15)],
    dependencies: [
        .package(url: "https://github.com/mr-elbe5/BandikaSwiftBase", from: "1.1.21"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SwiftyBandikaCL",
            dependencies: [
                "BandikaSwiftBase"
            ]),
        .testTarget(
            name: "SwiftyBandikaCLTests",
            dependencies: ["SwiftyBandikaCL"]),
    ]
)
