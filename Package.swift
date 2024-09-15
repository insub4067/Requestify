// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Requestify",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v12),
        .watchOS(.v4)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Requestify",
            targets: ["Requestify"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.4.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Requestify",
            dependencies: [
                .byName(name: "Alamofire")
            ]
        ),
        .testTarget(
            name: "RequestifyTests",
            dependencies: ["Requestify"]),
    ]
)
