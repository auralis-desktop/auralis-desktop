// Auralis: Notification service -- DBus org.freedesktop.Notifications

pragma Singleton
import Quickshell
import Quickshell.Io
import Quickshell.DBus
import QtQuick

QtObject {
    id: root

    property var    notifications:  []
    property var    history:        []
    property bool   dnd:            false
    property int    unreadCount:    0
    signal newNotification(var notif)

    // DBus: expose org.freedesktop.Notifications
    DBusServiceObject {
        busType:     DBus.BusType.Session
        serviceName: "org.freedesktop.Notifications"
        objectPath:  "/org/freedesktop/Notifications"

        DBusInterface {
            interfaceName: "org.freedesktop.Notifications"

            // Notify(app_name, replaces_id, app_icon, summary, body, actions, hints, timeout)
            DBusMethod {
                name: "Notify"
                onCalled: function(args) {
                    var notif = {
                        id:       args[1] > 0 ? args[1] : Date.now(),
                        appName:  args[0] || "",
                        icon:     args[2] || "",
                        summary:  args[3] || "",
                        body:     args[4] || "",
                        actions:  args[5] || [],
                        hints:    args[6] || {},
                        timeout:  args[7],
                        time:     new Date()
                    }

                    // Replace if replaces_id > 0
                    if (args[1] > 0) {
                        root.notifications = root.notifications.filter(n => n.id !== args[1])
                    }

                    if (!root.dnd) {
                        root.notifications = [notif, ...root.notifications].slice(0, 50)
                        root.unreadCount++
                        root.newNotification(notif)

                        // Auto-dismiss after timeout
                        var ms = notif.timeout > 0 ? notif.timeout : 5000
                        Qt.createQmlObject(
                            'import QtQuick; Timer { interval: ' + ms + '; running: true; repeat: false; onTriggered: { destroy() } }',
                            root
                        )
                    }

                    root.history = [notif, ...root.history].slice(0, 200)
                    return notif.id
                }
                returnSignature: "u"
            }

            DBusMethod {
                name: "CloseNotification"
                onCalled: function(args) {
                    root.dismiss(args[0])
                }
            }

            DBusMethod {
                name: "GetServerInformation"
                onCalled: function() {
                    return ["Auralis", "auralis-shell", "1.0", "1.2"]
                }
                returnSignature: "ssss"
            }

            DBusMethod {
                name: "GetCapabilities"
                onCalled: function() {
                    return [["actions", "body", "body-markup", "icon-static", "persistence"]]
                }
                returnSignature: "as"
            }
        }
    }

    function dismiss(id) {
        notifications = notifications.filter(n => n.id !== id)
    }

    function dismissAll() {
        notifications = []
        unreadCount   = 0
    }

    function clearHistory() {
        history = []
    }

    function markRead() {
        unreadCount = 0
    }

    function toggleDnd() {
        dnd = !dnd
        if (dnd) dismissAll()
    }
}
