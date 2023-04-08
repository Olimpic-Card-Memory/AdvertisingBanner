// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdvertisingBanner",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AdvertisingBanner",
            targets: ["AdvertisingBanner"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/AlertService/AlertService", branch: "master"),
        .package(url: "https://github.com/Architecture-org/Architecture", branch: "master"),
        .package(url: "https://github.com/Firebase-com/FirestoreFirebase", branch: "master"),
        .package(url: "https://github.com/AppsFlyer-org/AppFlyerFramework", branch: "master"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
        .package(url: "https://github.com/URLsOpen/OpenURL", branch: "master"),
        .package(url: "https://github.com/Juanpe/SkeletonView.git", from: "1.7.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AdvertisingBanner",
            dependencies: [
                .product(name: "AlertService", package: "AlertService"),
                .product(name: "OpenURL", package: "OpenURL"),
                .product(name: "SnapKit", package: "SnapKit"),
                .product(name: "Architecture", package: "Architecture"),
                .product(name: "FirestoreFirebase", package: "FirestoreFirebase"),
                .product(name: "AppFlyerFramework", package: "AppFlyerFramework"),
                .product(name: "SkeletonView", package: "SkeletonView"),
            ]),
    ]
)
