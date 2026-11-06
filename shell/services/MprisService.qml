// Auralis: MPRIS media service via playerctl

pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    property string title:     ""
    property string artist:    ""
    property string album:     ""
    property string artUrl:    ""
    property string status:    "Stopped"   // Playing | Paused | Stopped
    property real   position:  0           // seconds
    property real   duration:  0           // seconds
    property string playerName: ""
    property var    players:   []

    property bool playing: status === "Playing"

    Timer {
        interval: 2000
        running:  true
        repeat:   true
        onTriggered: root._poll()
    }

    function _poll() {
        _metaProc.running = true
    }

    Process {
        id: _metaProc
        command: ["playerctl", "metadata", "--format",
            "{{playerName}}\n{{title}}\n{{artist}}\n{{album}}\n{{mpris:artUrl}}\n{{status}}\n{{position}}\n{{mpris:length}}"]
        stdout: StdioCollector {
            onStreamFinished: {
                var lines = content.split("\n")
                if (lines.length >= 6) {
                    root.playerName = lines[0].trim()
                    root.title      = lines[1].trim()
                    root.artist     = lines[2].trim()
                    root.album      = lines[3].trim()
                    root.artUrl     = lines[4].trim().replace("file://", "")
                    root.status     = lines[5].trim()
                    root.position   = (parseInt(lines[6]) || 0) / 1000000
                    root.duration   = (parseInt(lines[7]) || 0) / 1000000
                } else {
                    root.title   = ""
                    root.artist  = ""
                    root.status  = "Stopped"
                }
            }
        }
    }

    function playPause()  { _cmd("play-pause") }
    function next()       { _cmd("next") }
    function previous()   { _cmd("previous") }
    function stop()       { _cmd("stop") }

    function seekTo(seconds) {
        _seekProc.command = ["playerctl", "position", String(seconds)]
        _seekProc.running = true
    }

    function _cmd(c) {
        _cmdProc.command = ["playerctl", c]
        _cmdProc.running = true
        Qt.callLater(_poll)
    }

    Process { id: _cmdProc; command: [] }
    Process { id: _seekProc; command: [] }

    function formatTime(seconds) {
        var m = Math.floor(seconds / 60)
        var s = Math.floor(seconds % 60)
        return m + ":" + (s < 10 ? "0" : "") + s
    }

    Component.onCompleted: _poll()
}
