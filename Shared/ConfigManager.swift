import Foundation

class ConfigManager {
    static let shared = ConfigManager()

    let vllmDirectory: URL
    let configFile: URL

    private init() {
        let home = FileManager.default.homeDirectoryForCurrentUser
        vllmDirectory = home.appendingPathComponent(".vllm")
        configFile = vllmDirectory.appendingPathComponent("config.json")
    }

    func ensureDirectoryExists() {
        let fm = FileManager.default
        if !fm.fileExists(atPath: vllmDirectory.path) {
            try? fm.createDirectory(at: vllmDirectory, withIntermediateDirectories: true)
        }
    }

    func loadConfig() -> AppConfig {
        ensureDirectoryExists()

        let fm = FileManager.default
        guard fm.fileExists(atPath: configFile.path),
              let data = try? Data(contentsOf: configFile),
              let config = try? JSONDecoder().decode(AppConfig.self, from: data)
        else {
            let defaultConfig = AppConfig.defaultConfig
            saveConfig(defaultConfig)
            return defaultConfig
        }

        return config
    }

    func saveConfig(_ config: AppConfig) {
        ensureDirectoryExists()
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        if let data = try? encoder.encode(config) {
            try? data.write(to: configFile)
        }
    }

    func scriptPath(for script: String) -> String {
        return vllmDirectory.appendingPathComponent(script).path
    }

    /// All enabled commands flattened across categories, with global indices
    func enabledCommands() -> [IndexedCommand] {
        let config = loadConfig()
        let allCmds = config.allCommands()
        return allCmds.enumerated().compactMap { index, cmd in
            guard cmd.enabled, !cmd.script.isEmpty else { return nil }
            return IndexedCommand(index: index, command: cmd)
        }
    }

    /// Categories from config (or synthesized from legacy flat commands)
    func loadCategories() -> [CategoryConfig] {
        let config = loadConfig()
        if let categories = config.categories, !categories.isEmpty {
            return categories
        }
        // Legacy: wrap flat commands in a single category
        let commands = config.commands ?? []
        return [CategoryConfig(name: "Commands", commands: commands)]
    }
}
