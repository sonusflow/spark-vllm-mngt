// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "VLLMManager",
    platforms: [
        .macOS(.v13)
    ],
    targets: [
        .executableTarget(
            name: "VLLMManager",
            path: "Sources/VLLMManager"
        )
    ]
)
