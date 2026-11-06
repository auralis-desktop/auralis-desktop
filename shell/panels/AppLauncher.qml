// Auralis: Application launcher
// Centered popup, Material 3, grid + list view

import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../components" as C
import "../services" as Services
import "../themes" as Themes

WlrLayerShell {
    id: root

    layer:           WlrLayer.Overlay
    keyboardFocus:   WlrKeyboardFocus.OnDemand
    anchors.top:     true
    anchors.left:    true
    anchors.right:   true
    anchors.bottom:  true

    onVisibleChanged: if (visible) { _search.text = ""; _search.forceActiveFocus() }

    // Dim backdrop
    Rectangle {
        anchors.fill: parent
        color:        "#000000"
        opacity:      root.visible ? 0.4 : 0
        Behavior on opacity { NumberAnimation { duration: 200 } }

        MouseArea {
            anchors.fill: parent
            onClicked:    root.visible = false
        }
    }

    // Launcher card
    C.Surface {
        id: _card
        width:   Services.Settings.launcherWidth
        anchors.top:              parent.top
        anchors.topMargin:        Services.Settings.barHeight + 8
        anchors.horizontalCenter: parent.horizontalCenter
        elevation:  4
        radius:     Themes.AuralisTheme.shapeExtraLarge
        bgOpacity:  0.96
        height:     Math.min(_content.implicitHeight + 24, 560)
        clip:       true

        // Open/close animation
        scale:   root.visible ? 1.0 : 0.92
        opacity: root.visible ? 1.0 : 0.0
        Behavior on scale   { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
        Behavior on opacity { NumberAnimation { duration: 180 } }

        Column {
            id: _content
            anchors {
                top:   parent.top
                left:  parent.left
                right: parent.right
                margins: 16
            }
            spacing: 12

            // Search bar
            Rectangle {
                width:  parent.width
                height: 52
                radius: Themes.AuralisTheme.shapeFull
                color:  Themes.AuralisTheme.surfaceVariant

                Row {
                    anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; leftMargin: 16; rightMargin: 16 }
                    spacing: 12

                    C.MdIcon { name: "search"; size: 20; color: Themes.AuralisTheme.onSurfaceVariant; anchors.verticalCenter: parent.verticalCenter }

                    TextInput {
                        id: _search
                        width:       parent.width - 48
                        color:       Themes.AuralisTheme.onSurface
                        font.pixelSize: 16
                        font.family:    Themes.AuralisTheme.fontFamily
                        placeholderText: "Search apps..."
                        placeholderTextColor: Themes.AuralisTheme.onSurfaceVariant
                        anchors.verticalCenter: parent.verticalCenter
                        Keys.onEscapePressed: root.visible = false
                        Keys.onReturnPressed: {
                            if (_appGrid.count > 0) {
                                _launchApp(_filteredApps[0])
                            }
                        }
                    }

                    C.MdIcon {
                        name:    "close"
                        size:    18
                        color:   Themes.AuralisTheme.onSurfaceVariant
                        visible: _search.text !== ""
                        anchors.verticalCenter: parent.verticalCenter
                        MouseArea { anchors.fill: parent; onClicked: _search.text = "" }
                    }
                }
            }

            // App grid
            Flow {
                id: _appGrid
                width:   parent.width
                spacing: 8

                property int count: _filteredApps.length

                Repeater {
                    model: _filteredApps
                    delegate: _AppTile { app: modelData }
                }
            }

            // Empty state
            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                visible:  _filteredApps.length === 0
                spacing:  8
                topPadding: 32
                bottomPadding: 32

                C.MdIcon { name: "search"; size: 48; color: Themes.AuralisTheme.onSurfaceVariant; anchors.horizontalCenter: parent.horizontalCenter }
                Text {
                    text:  "No apps found"
                    color: Themes.AuralisTheme.onSurfaceVariant
                    font.pixelSize: 14
                    font.family:    Themes.AuralisTheme.fontFamily
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    // ── App data ─────────────────────────────────────────────────────────────
    property var _allApps: []
    property var _filteredApps: {
        var q = _search.text.toLowerCase()
        if (!q) return _allApps
        return _allApps.filter(a =>
            a.name.toLowerCase().includes(q) ||
            (a.comment || "").toLowerCase().includes(q)
        )
    }

    Process {
        id: _desktopProc
        command: ["bash", "-c",
            "find /usr/share/applications ~/.local/share/applications -name '*.desktop' 2>/dev/null | " +
            "xargs grep -l 'NoDisplay=false\\|^\\[Desktop Entry\\]' 2>/dev/null | head -200"]
        stdout: StdioCollector {
            onStreamFinished: {
                _parseDesktop.command = ["bash", "-c",
                    "python3 -c \"\nimport glob, configparser, json, sys\napps=[]\n" +
                    "for f in glob.glob('/usr/share/applications/*.desktop') + glob.glob('" +
                    StandardPaths.writableLocation(StandardPaths.HomeLocation) +
                    "/.local/share/applications/*.desktop'):\n" +
                    "    try:\n        c=configparser.ConfigParser(interpolation=None)\n        c.read(f)\n" +
                    "        s=c['Desktop Entry']\n        if s.get('NoDisplay','false').lower()=='true':continue\n" +
                    "        if not s.get('Exec'):continue\n" +
                    "        apps.append({'name':s.get('Name',''),'exec':s.get('Exec',''),'icon':s.get('Icon','application-x-executable'),'comment':s.get('Comment','')})\n" +
                    "    except:pass\nprint(json.dumps(sorted(apps,key=lambda x:x['name'].lower())))\n\""]
                _parseDesktop.running = true
            }
        }
    }

    Process {
        id: _parseDesktop
        command: []
        stdout: StdioCollector {
            onStreamFinished: {
                try { root._allApps = JSON.parse(content) }
                catch(e) { console.warn("AppLauncher: failed to parse apps", e) }
            }
        }
    }

    function _launchApp(app) {
        var exec = app.exec
            .replace(/%[uUfFdDnNickvm]/g, "")
            .trim()
        Qt.createQmlObject(
            'import Quickshell.Io; Process { command: ["bash","-c","' + exec.replace(/"/g, '\\"') + ' &"]; running: true }',
            root)
        root.visible = false
    }

    Component.onCompleted: _desktopProc.running = true

    // App tile component
    component _AppTile: Item {
        property var app
        width:  (Services.Settings.launcherWidth - 32 - 8 * 3) / 4
        height: width + 16

        Rectangle {
            anchors.fill: parent
            radius:       Themes.AuralisTheme.shapeMedium
            color:        Themes.AuralisTheme.primary
            opacity:      _tma.containsPress ? 0.2 : _tma.containsMouse ? 0.08 : 0
            Behavior on opacity { NumberAnimation { duration: 100 } }
        }

        Column {
            anchors.centerIn: parent
            spacing: 6

            // Icon (theme icon lookup)
            Image {
                width:   Services.Settings.launcherIconSize
                height:  Services.Settings.launcherIconSize
                anchors.horizontalCenter: parent.horizontalCenter
                source:  "image://theme/" + (app?.icon || "application-x-executable")
                fillMode: Image.PreserveAspectFit
                smooth:   true
                onStatusChanged: if (status === Image.Error) source = "image://theme/application-x-executable"
            }

            Text {
                text:  app?.name || ""
                color: Themes.AuralisTheme.onSurface
                font.pixelSize: 11
                font.family:    Themes.AuralisTheme.fontFamily
                width:  parent.width ?? 80
                elide:  Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        MouseArea {
            id: _tma
            anchors.fill: parent
            hoverEnabled: true
            cursorShape:  Qt.PointingHandCursor
            onClicked:    root._launchApp(app)
        }
    }
}
