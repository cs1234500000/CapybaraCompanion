// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapybaraCompanion",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "CapybaraCompanion",
            targets: ["CapybaraCompanion"]
        )
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "CapybaraCompanion",
            path: "Sources"
        )
    ]
)
