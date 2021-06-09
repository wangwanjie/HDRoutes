// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HDRoutes",
    platforms: [
        .iOS(.v10),
    ],
    products: [
        .library(
            name: "HDRoutes",
            targets: ["HDRoutes"]
        )
    ],
    targets: [
        .target(
            name: "HDRoutes",
            path: "HDRoutes/Classes"
        )
    ]
)
