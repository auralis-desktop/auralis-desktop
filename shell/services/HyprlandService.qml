// Auralis: Hyprland IPC service
// Reads workspace and window state via hyprctl

pragma Singleton
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick

QtObject {
    id: root

    property var    workspaces:     []
    property int    activeWorkspace: 1
    property string activeWindow:   ""
    property string activeWindowClass: ""

    // Use Quickshell's built-in Hyprland integration
    HyprlandConnection {
        id: hypr
        onWorkspaceChanged: root._refreshWorkspaces()
        onActiveWindowChanged: root._refreshWindow()
    }

    function _refreshWorkspaces() {
        _wsProc.running = true
    }

    function _refreshWindow() {
        _winProc.running = true
    }

    Process {
        id: _wsProc
        command: ["hyprctl", "workspaces", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var ws = JSON.parse(content)
                    root.workspaces = ws.sort((a, b) => a.id - b.id)
                } catch(e) {}
            }
        }
    }

    Process {
        id: _winProc
        command: ["hyprctl", "activewindow", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var w = JSON.parse(content)
                    root.activeWindow      = w.title     || ""
                    root.activeWindowClass = w.class     || ""
                    root.activeWorkspace   = w.workspace?.id || root.activeWorkspace
                } catch(e) {
                    root.activeWindow = ""
                }
            }
        }
    }

    // Active workspace from Quickshell binding
    Process {
        id: _activeWsProc
        command: ["hyprctl", "activeworkspace", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var ws = JSON.parse(content)
                    root.activeWorkspace = ws.id || 1
                } catch(e) {}
            }
        }
    }

    function switchTo(id) {
        _switchProc.command = ["hyprctl", "dispatch", "workspace", String(id)]
        _switchProc.running = true
    }

    Process { id: _switchProc; command: [] }

    // Poll every 1s as fallback for missed events
    Timer {
        interval: 1000
        running:  true
        repeat:   true
        onTriggered: {
            _activeWsProc.running = true
            _winProc.running      = true
        }
    }

    Component.onCompleted: {
        _refreshWorkspaces()
        _refreshWindow()
    }
}
