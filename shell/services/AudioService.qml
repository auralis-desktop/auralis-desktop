// Auralis: Audio service via PipeWire / wpctl

pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    property real  volume:      0.5     // 0.0 – 1.0
    property bool  muted:       false
    property real  micVolume:   0.5
    property bool  micMuted:    false
    property string sinkName:   ""

    // ── Update loop ──────────────────────────────────────────────────────────
    Timer {
        interval: 2000
        running:  true
        repeat:   true
        onTriggered: root._poll()
    }

    function _poll() {
        _volProc.running = true
    }

    // Get volume: wpctl get-volume @DEFAULT_AUDIO_SINK@
    Process {
        id: _volProc
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: StdioCollector {
            onStreamFinished: {
                // Output: "Volume: 0.50" or "Volume: 0.50 [MUTED]"
                var text = content.trim()
                var match = text.match(/Volume:\s+([\d.]+)(\s+\[MUTED\])?/)
                if (match) {
                    root.volume = parseFloat(match[1])
                    root.muted  = match[2] !== undefined
                }
            }
        }
    }

    function setVolume(v) {
        volume = Math.max(0, Math.min(1.5, v))
        _setVolProc.command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", (volume * 100).toFixed(0) + "%"]
        _setVolProc.running = true
    }

    function toggleMute() {
        _muteProc.command = ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
        _muteProc.running = true
        Qt.callLater(_poll)
    }

    function setMicVolume(v) {
        micVolume = Math.max(0, Math.min(1, v))
        _setMicProc.command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SOURCE@", (micVolume * 100).toFixed(0) + "%"]
        _setMicProc.running = true
    }

    function toggleMicMute() {
        _micMuteProc.command = ["wpctl", "set-mute", "@DEFAULT_AUDIO_SOURCE@", "toggle"]
        _micMuteProc.running = true
    }

    Process { id: _setVolProc;  command: [] }
    Process { id: _muteProc;    command: [] }
    Process { id: _setMicProc;  command: [] }
    Process { id: _micMuteProc; command: [] }

    // Volume icon helper
    function volumeIcon() {
        if (muted || volume === 0) return "volume_off"
        if (volume < 0.33)        return "volume_mute"
        if (volume < 0.66)        return "volume_down"
        return "volume_up"
    }

    Component.onCompleted: _poll()
}
