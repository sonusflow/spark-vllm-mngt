// spark-vllm-mngt — github.com/sonusflow/spark-vllm-mngt
// Copyright (c) 2026 sonusflow. MIT License.

import AppKit

let app = NSApplication.shared
app.setActivationPolicy(.accessory)

let delegate = AppDelegate()
app.delegate = delegate

app.run()
