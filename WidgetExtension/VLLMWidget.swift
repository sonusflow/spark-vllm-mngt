// spark-vllm-mngt — github.com/sonusflow/spark-vllm-mngt
// Copyright (c) 2026 sonusflow. MIT License.

import WidgetKit
import SwiftUI

// MARK: - Timeline Entry

struct VLLMEntry: TimelineEntry {
    let date: Date
    let commands: [IndexedCommand]
}

// MARK: - Timeline Provider

struct VLLMTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> VLLMEntry {
        VLLMEntry(date: Date(), commands: [
            IndexedCommand(index: 0, command: CommandConfig(name: "Command 1", script: "example.sh", enabled: true)),
            IndexedCommand(index: 1, command: CommandConfig(name: "Command 2", script: "example.sh", enabled: true)),
        ])
    }

    func getSnapshot(in context: Context, completion: @escaping (VLLMEntry) -> Void) {
        let commands = ConfigManager.shared.enabledCommands()
        completion(VLLMEntry(date: Date(), commands: commands))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<VLLMEntry>) -> Void) {
        let commands = ConfigManager.shared.enabledCommands()
        let entry = VLLMEntry(date: Date(), commands: commands)
        // Refresh every 15 minutes
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date()
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

// MARK: - Shared Components

struct CommandButtonView: View {
    let command: IndexedCommand

    var body: some View {
        Button(intent: RunScriptIntent(commandIndex: command.id)) {
            HStack {
                Image(systemName: "play.fill")
                    .font(.caption2)
                Text(command.name)
                    .font(.caption)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.bordered)
        .tint(.blue)
    }
}

// MARK: - Widget Views

struct VLLMWidgetSmallView: View {
    var entry: VLLMEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "terminal")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("vLLM")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
            }

            if entry.commands.isEmpty {
                Text("No commands configured")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            } else {
                ForEach(entry.commands.prefix(2)) { cmd in
                    CommandButtonView(command: cmd)
                }
            }
            Spacer(minLength: 0)
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct VLLMWidgetMediumView: View {
    var entry: VLLMEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "terminal")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("vLLM Manager")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                Spacer()
            }

            if entry.commands.isEmpty {
                Text("No commands configured")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                Text("Edit ~/.vllm/config.json")
                    .font(.caption2)
                    .foregroundStyle(.quaternary)
            } else {
                let rows = stride(from: 0, to: entry.commands.count, by: 2).map { i in
                    Array(entry.commands[i..<min(i + 2, entry.commands.count)])
                }
                ForEach(rows, id: \.first?.id) { row in
                    HStack(spacing: 6) {
                        ForEach(row) { cmd in
                            CommandButtonView(command: cmd)
                        }
                        if row.count == 1 {
                            Spacer()
                        }
                    }
                }
            }
            Spacer(minLength: 0)
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct VLLMWidgetEntryView: View {
    var entry: VLLMEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            VLLMWidgetSmallView(entry: entry)
        default:
            VLLMWidgetMediumView(entry: entry)
        }
    }
}

// MARK: - Widget Definition

struct VLLMWidget: Widget {
    let kind: String = "VLLMWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: VLLMTimelineProvider()) { entry in
            VLLMWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("vLLM Manager")
        .description("Quick access to your vLLM scripts")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Widget Bundle (entry point)

@main
struct VLLMWidgetBundle: WidgetBundle {
    var body: some Widget {
        VLLMWidget()
    }
}
