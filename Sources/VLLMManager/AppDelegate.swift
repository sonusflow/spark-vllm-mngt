import AppKit
import WidgetKit

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var categories: [CategoryConfig] = []
    private var flatCommands: [CommandConfig] = []

    func applicationDidFinishLaunching(_ notification: Notification) {
        ScriptRunner.requestNotificationPermission()

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.title = "vLLM"
            button.font = NSFont.monospacedSystemFont(ofSize: 12, weight: .medium)
        }

        reloadData()
        buildMenu()
    }

    private func reloadData() {
        categories = ConfigManager.shared.loadCategories()
        // Build flat command list with global indices for tag-based dispatch
        flatCommands = categories.flatMap { $0.commands }
    }

    private func buildMenu() {
        let menu = NSMenu()

        var globalIndex = 0

        for category in categories {
            let submenu = NSMenu()

            for cmd in category.commands {
                let item = NSMenuItem(title: cmd.name, action: #selector(runCommand(_:)), keyEquivalent: "")
                item.target = self
                item.tag = globalIndex

                if !cmd.enabled || cmd.script.isEmpty {
                    item.isEnabled = false
                    let attrs: [NSAttributedString.Key: Any] = [
                        .foregroundColor: NSColor.tertiaryLabelColor,
                        .font: NSFont.systemFont(ofSize: 14)
                    ]
                    item.attributedTitle = NSAttributedString(string: cmd.name + " (not configured)", attributes: attrs)
                }

                submenu.addItem(item)
                globalIndex += 1
            }

            let categoryItem = NSMenuItem(title: category.name, action: nil, keyEquivalent: "")
            categoryItem.submenu = submenu
            menu.addItem(categoryItem)
        }

        menu.addItem(NSMenuItem.separator())

        let editConfig = NSMenuItem(title: "Edit Config...", action: #selector(editConfig), keyEquivalent: "e")
        editConfig.target = self
        menu.addItem(editConfig)

        let editSettings = NSMenuItem(title: "Edit Settings...", action: #selector(editSettings), keyEquivalent: "s")
        editSettings.target = self
        menu.addItem(editSettings)

        let openFolder = NSMenuItem(title: "Open Scripts Folder", action: #selector(openScriptsFolder), keyEquivalent: "o")
        openFolder.target = self
        menu.addItem(openFolder)

        let reload = NSMenuItem(title: "Reload Config", action: #selector(reloadConfig), keyEquivalent: "r")
        reload.target = self
        menu.addItem(reload)

        menu.addItem(NSMenuItem.separator())

        let quit = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q")
        quit.target = self
        menu.addItem(quit)

        statusItem.menu = menu
    }

    @objc private func runCommand(_ sender: NSMenuItem) {
        let index = sender.tag
        guard index >= 0, index < flatCommands.count else { return }
        let cmd = flatCommands[index]
        guard cmd.enabled, !cmd.script.isEmpty else { return }
        ScriptRunner.run(script: cmd.script, name: cmd.name)
    }

    @objc private func editConfig() {
        NSWorkspace.shared.open(URL(fileURLWithPath: ConfigManager.shared.configFile.path))
    }

    @objc private func editSettings() {
        let settingsPath = ConfigManager.shared.vllmDirectory.appendingPathComponent("settings.env").path
        if FileManager.default.fileExists(atPath: settingsPath) {
            NSWorkspace.shared.open(URL(fileURLWithPath: settingsPath))
        } else {
            ScriptRunner.showNotification(
                title: "vLLM",
                body: "settings.env not found. Run install.sh to create it.",
                success: false
            )
        }
    }

    @objc private func openScriptsFolder() {
        NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: ConfigManager.shared.vllmDirectory.path)
    }

    @objc private func reloadConfig() {
        reloadData()
        buildMenu()
        WidgetCenter.shared.reloadAllTimelines()
        ScriptRunner.showNotification(title: "vLLM", body: "Configuration reloaded", success: true)
    }

    @objc private func quitApp() {
        NSApp.terminate(nil)
    }
}
