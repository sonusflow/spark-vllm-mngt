// spark-vllm-mngt — github.com/sonusflow/spark-vllm-mngt
// Copyright (c) 2026 sonusflow. MIT License.

import Foundation

struct CommandConfig: Codable {
    var name: String
    var script: String
    var enabled: Bool
}

struct CategoryConfig: Codable {
    var name: String
    var commands: [CommandConfig]
}

struct SettingsConfig: Codable {
    var sparkHost: String?
    var sparkUser: String?
    var sparkVllmDir: String?

    enum CodingKeys: String, CodingKey {
        case sparkHost = "spark_host"
        case sparkUser = "spark_user"
        case sparkVllmDir = "spark_vllm_dir"
    }
}

struct AppConfig: Codable {
    // New categorized format
    var settings: SettingsConfig?
    var categories: [CategoryConfig]?

    // Legacy flat format
    var commands: [CommandConfig]?

    /// All commands flattened across categories (or legacy commands)
    func allCommands() -> [CommandConfig] {
        if let categories = categories {
            return categories.flatMap { $0.commands }
        }
        return commands ?? []
    }

    static let defaultConfig = AppConfig(
        settings: SettingsConfig(
            sparkHost: "YOUR_DGX_IP",
            sparkUser: "YOUR_USERNAME",
            sparkVllmDir: "/path/to/spark-vllm-docker"
        ),
        categories: [
            CategoryConfig(name: "Recipes — LLM", commands: [
                CommandConfig(name: "GLM-4.7 Flash AWQ", script: "recipes/glm-4.7-flash-awq.sh", enabled: true),
                CommandConfig(name: "MiniMax M2 AWQ", script: "recipes/minimax-m2-awq.sh", enabled: true),
                CommandConfig(name: "MiniMax M2.5 AWQ", script: "recipes/minimax-m2.5-awq.sh", enabled: true),
                CommandConfig(name: "Nemotron Nano NVFP4", script: "recipes/nemotron-3-nano-nvfp4.sh", enabled: true),
                CommandConfig(name: "OpenAI GPT-OSS 120B", script: "recipes/openai-gpt-oss-120b.sh", enabled: true),
            ]),
            CategoryConfig(name: "Recipes — Coding", commands: [
                CommandConfig(name: "Qwen3 Coder FP8", script: "recipes/qwen3-coder-next-fp8.sh", enabled: true),
                CommandConfig(name: "Qwen3.5 122B FP8", script: "recipes/qwen3.5-122b-fp8.sh", enabled: true),
                CommandConfig(name: "Qwen3.5 122B INT4", script: "recipes/qwen3.5-122b-int4-autoround.sh", enabled: true),
                CommandConfig(name: "Qwen3.5 35B-A3B FP8", script: "recipes/qwen35-35b-a3b-fp8.sh", enabled: true),
            ]),
            CategoryConfig(name: "Cluster", commands: [
                CommandConfig(name: "Status", script: "utilities/cluster-status.sh", enabled: true),
                CommandConfig(name: "Stop", script: "utilities/cluster-stop.sh", enabled: true),
                CommandConfig(name: "Logs", script: "utilities/cluster-logs.sh", enabled: true),
                CommandConfig(name: "Health Check", script: "utilities/health-check.sh", enabled: true),
            ]),
            CategoryConfig(name: "Build & Setup", commands: [
                CommandConfig(name: "Build Image", script: "utilities/build-image.sh", enabled: true),
                CommandConfig(name: "Download Model", script: "utilities/download-model.sh", enabled: true),
            ]),
        ],
        commands: nil
    )
}

struct IndexedCommand: Identifiable {
    let id: Int
    let name: String
    let script: String

    init(index: Int, command: CommandConfig) {
        self.id = index
        self.name = command.name
        self.script = command.script
    }
}
