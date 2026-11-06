// Auralis: Network service via NetworkManager CLI

pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    property bool   connected:    false
    property bool   wifi:         false
    property string ssid:         ""
    property int    signal:       0       // 0-100
    property bool   wifiEnabled:  true
    property string ipAddress:    ""
    property var    accessPoints: []

    Timer {
        interval: 5000
        running:  true
        repeat:   true
        onTriggered: root._poll()
    }

    function _poll() {
        _statusProc.running = true
    }

    // nmcli -t -f ACTIVE,SSID,SIGNAL,BARS dev wifi
    Process {
        id: _statusProc
        command: ["nmcli", "-t", "-f", "ACTIVE,SSID,SIGNAL,CONNECTIVITY", "general"]
        stdout: StdioCollector {
            onStreamFinished: {
                var lines = content.trim().split("\n")
                for (var l of lines) {
                    var parts = l.split(":")
                    if (parts.length >= 4) {
                        root.connected = parts[3] === "full"
                    }
                }
                _wifiProc.running = true
            }
        }
    }

    Process {
        id: _wifiProc
        command: ["nmcli", "-t", "-f", "ACTIVE,SSID,SIGNAL", "dev", "wifi"]
        stdout: StdioCollector {
            onStreamFinished: {
                var lines = content.trim().split("\n")
                var aps = []
                for (var l of lines) {
                    var parts = l.split(":")
                    if (parts.length >= 3) {
                        var active = parts[0] === "yes"
                        var ssid   = parts[1]
                        var sig    = parseInt(parts[2]) || 0
                        aps.push({ ssid, signal: sig, active })
                        if (active) {
                            root.ssid   = ssid
                            root.signal = sig
                            root.wifi   = true
                        }
                    }
                }
                root.accessPoints = aps
                if (aps.length === 0) root.wifi = false
            }
        }
    }

    function toggleWifi() {
        var cmd = wifiEnabled ? "off" : "on"
        _toggleProc.command = ["nmcli", "radio", "wifi", cmd]
        _toggleProc.running = true
        wifiEnabled = !wifiEnabled
        Qt.callLater(_poll)
    }

    function connectTo(ssid) {
        _connectProc.command = ["nmcli", "dev", "wifi", "connect", ssid]
        _connectProc.running = true
    }

    Process { id: _toggleProc;  command: [] }
    Process { id: _connectProc; command: [] }

    function signalIcon() {
        if (!wifi || !connected) return "wifi_off"
        if (signal >= 75) return "wifi"
        if (signal >= 50) return "wifi_2_bar"
        if (signal >= 25) return "wifi_1_bar"
        return "wifi_find"
    }

    Component.onCompleted: _poll()
}
