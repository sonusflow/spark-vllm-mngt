// spark-vllm-mngt — github.com/sonusflow/spark-vllm-mngt
// Copyright (c) 2026 sonusflow. MIT License.

import AppIntents
import Foundation

struct RunScriptIntent: AppIntent {
    static var title: LocalizedStringResource = "Run vLLM Script"
    static var description = IntentDescription("Runs a configured vLLM shell script")
    static var openAppWhenRun: Bool = true

    @Parameter(title: "Command Index")
    var commandIndex: Int

    init() {
        self.commandIndex = 0
    }

    init(commandIndex: Int) {
        self.commandIndex = commandIndex
    }

    func perform() async throws -> some IntentResult {
        let config = ConfigManager.shared.loadConfig()
        let allCmds = config.allCommands()
        guard commandIndex >= 0, commandIndex < allCmds.count else {
            return .result()
        }

        let cmd = allCmds[commandIndex]
        guard cmd.enabled, !cmd.script.isEmpty else {
            return .result()
        }

        ScriptRunner.run(script: cmd.script, name: cmd.name)
        return .result()
    }
}
