// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BannerAdvertising",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "BannerAdvertising",
            targets: ["BannerAdvertising"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/it-senior-developer/VVMLibrary", branch: "master"),
        .package(url: "https://github.com/it-senior-developer/FirebaseBackend", branch: "master"),
        .package(url: "https://github.com/it-senior-developer/AdvertisingAppsFlyer", branch: "master"),
        .package(url: "https://github.com/Juanpe/SkeletonView.git", from: "1.7.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "BannerAdvertising",
            dependencies: [
                .product(name: "VVMLibrary", package: "VVMLibrary"),
                .product(name: "FirebaseBackend", package: "FirebaseBackend"),
                .product(name: "AdvertisingAppsFlyer", package: "AdvertisingAppsFlyer"),
                .product(name: "SkeletonView", package: "SkeletonView"),
            ]),
    ]
)
