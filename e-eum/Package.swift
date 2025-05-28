// swift-tools-version: 5.9
// This is a Skip (https://skip.tools) package.
import PackageDescription

let package = Package(
    name: "e-eum",
    defaultLocalization: "en",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "E_Eum", type: .dynamic, targets: ["E_Eum"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "1.4.8"),
        .package(url: "https://source.skip.tools/skip-ui.git", from: "1.0.0"),
        .package(url: "https://github.com/skiptools/skip-web", from: "0.1.0"),
        .package(url: "https://github.com/skiptools/skip-kit", from: "0.4.0"),
        .package(url: "https://github.com/skiptools/skip-device", from: "0.4.0"),
        .package(url: "https://github.com/skiptools/skip-keychain", from: "0.3.0")
    ],
    targets: [
        .target(name: "E_Eum", dependencies: [
            .product(name: "SkipUI", package: "skip-ui"),
            .product(name: "SkipWeb", package: "skip-web"),
            .product(name: "SkipKit", package: "skip-kit"),
            .product(name: "SkipDevice", package: "skip-device"),
            .product(name: "SkipKeychain", package: "skip-keychain")
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "E_EumTests", dependencies: [
            "E_Eum",
            .product(name: "SkipTest", package: "skip")
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)
