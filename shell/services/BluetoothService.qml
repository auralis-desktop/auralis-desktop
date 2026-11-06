// Auralis: Bluetooth service via bluetoothctl

pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    property bool   enabled:    false
    property bool   connected:  false
    property string deviceName: ""
    property var    devices:    []

    Timer {
        interval: 8000
        running:  true
        repeat:   true
        onTriggered: root._poll()
    }

    function _poll() {
        _showProc.running = true
    }

    // bluetoothctl show
    Process {
        id: _showProc
        command: ["bluetoothctl", "show"]
        stdout: StdioCollector {
            onStreamFinished: {
                var lines = content.split("\n")
                for (var l of lines) {
                    if (l.includes("Powered:")) {
                        root.enabled = l.includes("yes")
                    }
                }
                _devProc.running = true
            }
        }
    }

    // bluetoothctl devices Connected
    Process {
        id: _devProc
        command: ["bluetoothctl", "devices", "Connected"]
        stdout: StdioCollector {
            onStreamFinished: {
                var lines = content.trim().split("\n").filter(l => l.trim())
                root.connected  = lines.length > 0
                root.deviceName = lines.length > 0 ? lines[0].replace(/^Device\s+[0-9A-F:]+\s+/, "").trim() : ""
            }
        }
    }

    function toggle() {
        var cmd = enabled ? "power off" : "power on"
        _pwrProc.command = ["bluetoothctl", cmd]
        _pwrProc.running = true
        enabled = !enabled
    }

    Process { id: _pwrProc; command: [] }

    function icon() {
        if (!enabled)  return "bluetooth_disabled"
        if (connected) return "bluetooth_connected"
        return "bluetooth"
    }

    Component.onCompleted: _poll()
}
