// spark-vllm-mngt — github.com/sonusflow/spark-vllm-mngt
// Copyright (c) 2026 sonusflow. MIT License.
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
