# vLLM Manager

A macOS menu bar app + Notification Center widget for managing [vLLM](https://docs.vllm.ai/) inference on NVIDIA DGX Spark via [spark-vllm-docker](https://github.com/eugr/spark-vllm-docker).

![macOS 15+](https://img.shields.io/badge/macOS-15%2B-blue) ![Swift 5.9](https://img.shields.io/badge/Swift-5.9-orange) ![License](https://img.shields.io/badge/license-MIT-green)

## What it does

- **Menu bar app** with categorized dropdown menus for launching recipes and cluster utilities via SSH
- **Notification Center widget** (WidgetKit) with quick-access buttons for your most-used commands
- **Template scripts** for all spark-vllm-docker recipes — just fill in your connection details

### Supported Recipes

| Category | Models |
|----------|--------|
| **LLM** | GLM-4.7 Flash AWQ, MiniMax M2 AWQ, MiniMax M2.5 AWQ, Nemotron Nano NVFP4, OpenAI GPT-OSS 120B |
| **Coding** | Qwen3 Coder FP8, Qwen3.5 122B FP8, Qwen3.5 122B INT4, Qwen3.5 35B-A3B FP8 |

### Cluster Utilities

Status, Stop, Logs, Health Check, Build Image, Download Model

## Prerequisites

- macOS 15.0+
- Xcode 15+ (with command line tools)
- [xcodegen](https://github.com/yonaskolb/XcodeGen): `brew install xcodegen`
- SSH access to your DGX Spark (key-based auth recommended)
- [spark-vllm-docker](https://github.com/eugr/spark-vllm-docker) set up on your Spark

## Install

```bash
git clone https://github.com/sonusflow/spark-vllm-mngt.git
cd vllm-mngt
bash scripts/install.sh
```

This will:
1. Copy template scripts to `~/.vllm/`
2. Create `~/.vllm/settings.env` with connection placeholders
3. Build the app and install to `/Applications/`

## Configure

Edit your connection settings:

```bash
nano ~/.vllm/settings.env
```

```env
SPARK_HOST=192.168.1.100        # Your DGX Spark IP
SPARK_USER=your-username         # SSH username
SPARK_VLLM_DIR=/home/user/spark-vllm-docker  # Path on Spark
VLLM_PORT=8000                   # vLLM API port
```

## Add the Widget

1. Click the date/time in your menu bar
2. Click **Edit Widgets** at the bottom
3. Search for **vLLM**
4. Drag the widget to your Notification Center

## Project Structure

```
├── Shared/                  # Code shared between app and widget
│   ├── Models.swift         # Config data models
│   ├── ConfigManager.swift  # Config loading/saving
│   ├── ScriptRunner.swift   # Script execution + notifications
│   └── RunScriptIntent.swift # AppIntent for widget buttons
├── Sources/VLLMManager/     # Menu bar app
│   ├── AppDelegate.swift    # Category submenus, menu bar UI
│   └── main.swift           # Entry point
├── WidgetExtension/         # Notification Center widget
│   ├── VLLMWidget.swift     # Widget timeline + UI
│   └── Info.plist
├── templates/               # Script templates (copied to ~/.vllm/)
│   ├── _common.sh           # SSH wrapper (shared by all scripts)
│   ├── settings.env         # Connection settings template
│   ├── recipes/             # Model launch scripts
│   └── utilities/           # Cluster management scripts
├── scripts/
│   ├── install.sh           # One-command setup
│   └── build-app.sh         # Build with xcodegen + xcodebuild
├── project.yml              # xcodegen project config
└── resources/Info.plist     # App metadata
```

## Configuration

The app uses `~/.vllm/config.json` for menu structure. A default config is generated on first launch with all recipes and utilities organized by category.

To customize which commands appear and their names, edit the config:

```bash
open ~/.vllm/config.json
```

Or use **Edit Config...** from the menu bar dropdown.

### Adding Custom Commands

Add entries to any category in `config.json`:

```json
{
  "categories": [
    {
      "name": "My Category",
      "commands": [
        {
          "name": "My Script",
          "script": "my-script.sh",
          "enabled": true
        }
      ]
    }
  ]
}
```

Place the script in `~/.vllm/` and make it executable (`chmod +x`).

## Build from Source

```bash
# Generate Xcode project and build
bash scripts/build-app.sh

# Or manually:
xcodegen generate
xcodebuild -project VLLMManager.xcodeproj -scheme VLLMManager -configuration Release \
  CODE_SIGN_IDENTITY="-" DEVELOPMENT_TEAM="" \
  -derivedDataPath .build/DerivedData build
```

## Credits

- [spark-vllm-docker](https://github.com/eugr/spark-vllm-docker) by eugr — Docker-based vLLM inference for DGX Spark
- [vLLM](https://docs.vllm.ai/) — High-throughput LLM serving engine

## License

MIT
