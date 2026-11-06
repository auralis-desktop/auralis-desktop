// Auralis: Wallpaper service via swww

pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    property string current:   ""
    property var    wallpapers: []
    property string directory: "~/Pictures/Wallpapers"

    function scan(dir) {
        directory = dir || directory
        _scanProc.command = ["bash", "-c",
            "find " + directory.replace("~", "$HOME") +
            " -type f \\( -iname '*.jpg' -o -iname '*.jpeg' " +
            "-o -iname '*.png' -o -iname '*.webp' \\) 2>/dev/null | sort"
        ]
        _scanProc.running = true
    }

    function setWallpaper(path, transition) {
        var t = transition || "fade"
        current = path
        _setProc.command = [
            "swww", "img", path,
            "--transition-type", t,
            "--transition-duration", "1",
            "--transition-fps", "60"
        ]
        _setProc.running = true
    }

    Process {
        id: _scanProc
        command: []
        stdout: StdioCollector {
            onStreamFinished: {
                root.wallpapers = content.trim().split("\n").filter(l => l.trim())
            }
        }
    }

    Process {
        id: _setProc
        command: []
    }

    Component.onCompleted: scan()
}
