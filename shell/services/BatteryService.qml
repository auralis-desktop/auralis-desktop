// Auralis: Battery service via /sys/class/power_supply

pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    property int    percentage:    100
    property string status:        "Unknown"   // Charging / Discharging / Full / Not charging
    property bool   charging:      false
    property bool   present:       false
    property int    timeRemaining: -1   // minutes, -1 = unknown

    // Check every 30 s (battery changes slowly)
    Timer {
        interval: 30000
        running:  true
        repeat:   true
        onTriggered: root._poll()
    }

    function _poll() {
        _capacityProc.running = true
    }

    Process {
        id: _capacityProc
        command: ["bash", "-c",
            "cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || " +
            "cat /sys/class/power_supply/BAT1/capacity 2>/dev/null || echo -1"]
        stdout: StdioCollector {
            onStreamFinished: {
                var v = parseInt(content.trim())
                if (v >= 0) {
                    root.percentage = v
                    root.present    = true
                } else {
                    root.present = false
                }
            }
        }
    }

    Process {
        id: _statusProc
        command: ["bash", "-c",
            "cat /sys/class/power_supply/BAT0/status 2>/dev/null || " +
            "cat /sys/class/power_supply/BAT1/status 2>/dev/null || echo Unknown"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.status   = content.trim()
                root.charging = root.status === "Charging" || root.status === "Not charging"
            }
        }
    }

    // Trigger status poll after capacity
    onPercentageChanged: _statusProc.running = true

    function icon() {
        if (!present)  return "battery_unknown"
        if (charging)  return "battery_charging_full"
        if (percentage >= 90) return "battery_full"
        if (percentage >= 70) return "battery_6_bar"
        if (percentage >= 50) return "battery_4_bar"
        if (percentage >= 30) return "battery_3_bar"
        if (percentage >= 15) return "battery_2_bar"
        if (percentage >= 5)  return "battery_1_bar"
        return "battery_alert"
    }

    function color() {
        if (percentage <= 15 && !charging) return "#F2B8B5"  // error
        if (charging) return "#B5CC8E"
        return ""  // default theme color
    }

    Component.onCompleted: _poll()
}
