// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TubeArchivistKit",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .tvOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "TubeArchivistKit",
            targets: ["TubeArchivistKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.2"),
//        .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "24.0.0"),
//        .package(url: "https://github.com/stephencelis/SQLite.swift.git", from: "0.15.4")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "TubeArchivistKit",
            dependencies: [
                .product(name: "SwiftyJSON", package: "SwiftyJSON"),
//                .product(name: "KeychainSwift", package: "keychain-swift"),
//                .product(name: "SQLite", package: "SQLite.swift")
            ]),
        .testTarget(
            name: "TubeArchivistKitTests",
            dependencies: ["TubeArchivistKit"]
        ),
    ]
)
