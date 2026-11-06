// Auralis Shell -- Main entry point
// Quickshell root; spawns all shell surfaces

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import "./services" as Services
import "./themes" as Themes
import "./panels" as Panels

ShellRoot {
    id: root

    // ── Global singletons ────────────────────────────────────────────────────
    Themes.AuralisTheme  { id: theme }
    Services.Settings    { id: settings }
    Services.AudioService       { id: audioService }
    Services.NetworkService     { id: networkService }
    Services.BluetoothService   { id: bluetoothService }
    Services.BatteryService     { id: batteryService }
    Services.NotificationService { id: notifService }
    Services.MprisService       { id: mprisService }
    Services.HyprlandService    { id: hyprlandService }
    Services.WallpaperService   { id: wallpaperService }

    // ── IPC: toggling panels from keybinds ───────────────────────────────────
    IpcHandler {
        target: "auralis"

        function toggleLauncher()      { launcherPanel.visible = !launcherPanel.visible }
        function toggleNotifications() { notifCenter.visible   = !notifCenter.visible   }
        function toggleSettings()      { settingsPanel.visible = !settingsPanel.visible  }
        function toggleDashboard()     { dashboardPanel.visible = !dashboardPanel.visible }
        function toggleQuickSettings() { quickSettingsPanel.visible = !quickSettingsPanel.visible }
        function openPowerMenu()       { powerMenu.visible = true }
    }

    // ── Surfaces ──────────────────────────────────────────────────────────────
    Panels.TopBar           { id: topBar          }
    Panels.AppLauncher      { id: launcherPanel; visible: false }
    Panels.QuickSettings    { id: quickSettingsPanel; visible: false }
    Panels.NotificationCenter { id: notifCenter; visible: false }
    Panels.Dashboard        { id: dashboardPanel; visible: false }
    Panels.PowerMenu        { id: powerMenu; visible: false }
    Panels.WallpaperPicker  { id: wallpaperPickerPanel; visible: false }
    Panels.SettingsWindow   { id: settingsPanel; visible: false }
}
