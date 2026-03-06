// spark-vllm-mngt — github.com/sonusflow/spark-vllm-mngt
// Copyright (c) 2026 sonusflow. MIT License.

import Foundation
import UserNotifications

class ScriptRunner {
    static func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    static func run(script: String, name: String) {
        let config = ConfigManager.shared
        let path = config.scriptPath(for: script)
        let fm = FileManager.default

        guard fm.fileExists(atPath: path) else {
            showNotification(title: "vLLM — \(name)", body: "Script not found: \(script)", success: false)
            return
        }

        guard fm.isExecutableFile(atPath: path) else {
            showNotification(title: "vLLM — \(name)", body: "Script is not executable: \(script)\nRun: chmod +x ~/.vllm/\(script)", success: false)
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/bin/bash")
            process.arguments = ["-l", path]
            process.currentDirectoryURL = config.vllmDirectory

            let pipe = Pipe()
            process.standardOutput = pipe
            process.standardError = pipe

            do {
                try process.run()
                process.waitUntilExit()

                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

                let success = process.terminationStatus == 0
                let summary = output.isEmpty ? (success ? "Completed successfully" : "Failed (exit \(process.terminationStatus))") :
                    String(output.suffix(200))

                DispatchQueue.main.async {
                    showNotification(title: "vLLM — \(name)", body: summary, success: success)
                }
            } catch {
                DispatchQueue.main.async {
                    showNotification(title: "vLLM — \(name)", body: "Failed to launch: \(error.localizedDescription)", success: false)
                }
            }
        }
    }

    static func showNotification(title: String, body: String, success: Bool) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        if !success {
            content.sound = .default
        }

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        UNUserNotificationCenter.current().add(request)
    }
}
