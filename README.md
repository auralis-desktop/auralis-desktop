# 🌊 Auralis

### A desktop that feels alive.

Auralis is a modern Hyprland desktop customization project built around a beautiful Material Design 3 experience, powered by Quickshell and a custom Lua-based Hyprland configuration.

Inspired by the elegance of Material You and the nostalgic beauty of Frutiger Aero, Auralis combines translucent aqua glass, smooth animations, dynamic colors, and powerful customization into one cohesive Linux desktop.

> ✨ A fresh, modern desktop experience for Arch Linux.

<p align="center">
  <img src="website/assets/auralis-preview.png" alt="Auralis Desktop Preview" width="90%">
</p>

<p align="center">
  <a href="#-installation">Installation</a> ·
  <a href="#-features">Features</a> ·
  <a href="#-customization">Customization</a> ·
  <a href="#-documentation">Documentation</a>
</p>

---

## ✨ Features

### 🎨 Material Design 3

- Modern Material 3 interface.
- Beautiful aqua-glass aesthetics.
- Dynamic accent colors.
- Light and dark themes.
- Rounded surfaces and smooth animations.
- Consistent design system.

### 🖥️ Auralis Shell

Powered by Quickshell and QML.

- Custom top bar.
- Application launcher.
- Quick Settings panel.
- Notification center.
- Media controls.
- Desktop dashboard.
- Wallpaper picker.
- System status widgets.

### ⚙️ Auralis Settings

Customize your desktop through a beautiful settings interface.

- Appearance and themes.
- Accent colors.
- Transparency and blur.
- Bar customization.
- Launcher settings.
- Quick Settings configuration.
- Wallpaper settings.
- Hyprland configuration.

### 🪟 Hyprland

A modular Hyprland configuration using Lua.

- Modular configuration.
- Custom animations.
- Window decorations.
- Workspace management.
- Keyboard shortcuts.
- Multi-monitor support.

### 📦 Installer

A convenient installation system for Arch Linux.

- Automatic package detection.
- Install missing dependencies.
- Configuration backups.
- Safe dotfiles installation.
- Installation verification.
- Update and uninstall support.

---

## 📸 Screenshots

Screenshots will be added as Auralis development progresses.

| Desktop | Launcher |
|---|---|
| Coming soon | Coming soon |

| Quick Settings | Settings |
|---|---|
| Coming soon | Coming soon |

---

## 🚀 Installation

### Requirements

- Arch Linux or a compatible Arch-based distribution.
- Hyprland.
- Quickshell.
- Git.
- An internet connection.
- An AUR helper if required dependencies are unavailable in official repositories.

### Install Auralis

Clone the repository:

```bash
git clone https://github.com/USERNAME/Auralis.git
```

Enter the project directory:

```bash
cd Auralis
```

Run the installer:

```bash
./install.sh
```

The installer will check your system, identify missing dependencies, install required packages, back up existing configurations, and install the Auralis dotfiles.

Review the installer before running it.

### Start Auralis

Log into your Hyprland session.

Quickshell should start automatically if the installation has configured the session correctly.

If needed, start it manually using the command documented for your installed Quickshell version.

---

## 🎨 Customization

Auralis is designed to be customizable.

### Quickshell

The Quickshell configuration is located at:

```text
~/.config/quickshell/
```

### Hyprland

The primary Hyprland configuration is:

```text
~/.config/hypr/hyprland.lua
```

### Settings

Use Auralis Settings to customize supported options such as:

- Theme.
- Accent color.
- Transparency.
- Blur.
- Bar position.
- Launcher appearance.
- Wallpaper.
- Animations.

Settings are designed to persist across sessions.

---

## 📁 Project Structure

```text
Auralis/
├── shell/
│   ├── components/
│   ├── panels/
│   ├── launcher/
│   ├── settings/
│   ├── services/
│   ├── themes/
│   └── widgets/
│
├── hyprland/
│   ├── hyprland.lua
│   └── config/
│
├── dotfiles/
│   └── .config/
│
├── installer/
│   ├── install.sh
│   ├── uninstall.sh
│   ├── update.sh
│   └── doctor.sh
│
├── website/
├── docs/
├── .github/
├── README.md
└── LICENSE
```

---

## 📚 Documentation

Detailed documentation will be available in the `docs/` directory and on the project website.

- Installation Guide
- Configuration Guide
- Settings Guide
- Keybindings
- Troubleshooting
- FAQ

---

## 🌐 Website

Visit the Auralis project website:

**[Auralis Website](https://auralis-desktop.github.io/)**

The website provides project information, installation instructions, documentation, and screenshots.

---

## 🛠️ Development

Auralis is actively developed.

The project is currently in its early development stage. Features, configuration options, and installation procedures may change.

Contributions, suggestions, bug reports, and feedback are welcome.

### Development Goals
everything done!
- [ ] Complete Quickshell desktop shell.
- [ ] Implement Material 3 settings.
- [ ] Finish Hyprland Lua configuration.
- [ ] Complete automatic installer.
- [ ] Add multi-monitor settings.
- [ ] Complete documentation.
- [ ] Publish the website.
- [ ] Release the first public beta.

---

## 🤝 Contributing

Contributions are welcome!

If you want to contribute:

1. Fork the repository.
2. Create a feature branch.
3. Make your changes.
4. Test your implementation.
5. Submit a pull request.

Please read `CONTRIBUTING.md` before submitting significant changes.

---

## 📄 License

Auralis is open-source software.

See the `LICENSE` file for license information.

---

## 💙 Credits

Auralis is inspired by:

- [Hyprland](https://hyprland.org/)
- [Quickshell](https://quickshell.org/)
- [Material Design 3](https://m3.material.io/)
- [Caelestia Shell](https://github.com/caelestia-dots/shell)

Auralis is an independent project and is not affiliated with Google, Hyprland, or Caelestia.

---

<p align="center">
  <strong>Auralis — A desktop that feels alive.</strong>
  <br>
  Made with 💙 for the Linux community.
</p>
