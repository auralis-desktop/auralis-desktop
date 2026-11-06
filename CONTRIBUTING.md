# Contributing to Auralis

Thanks for your interest in contributing!

## Ways to help

- Report bugs and issues
- Suggest features
- Fix typos in docs
- Improve QML components
- Test on different hardware
- Add wallpapers or themes

## Development setup

```bash
git clone https://github.com/auralis-desktop/auralis-desktop.git
cd auralis
# Install deps
./install.sh
# Edit shell files
code shell/
# Reload running shell
qs reload
```

## Code style

- QML: 4-space indent, one component per file, `id` on first line
- Lua: 2-space indent, comments on their own line
- Shell: `set -euo pipefail`, quote all variables

## Submitting changes

1. Fork the repository
2. Create a branch: `git checkout -b my-feature`
3. Make your changes
4. Test them (see below)
5. Open a pull request

## Testing

```bash
# Validate installer
bash -n installer/install.sh

# Validate Lua
luac -p hyprland/hyprland.lua
luac -p hyprland/config/*.lua

# Run Quickshell with your changes
quickshell -c ./shell
```

## Reporting bugs

Please include:
- Hyprland version (`hyprctl version`)
- Quickshell version (`qs --version`)
- Distribution and GPU
- Steps to reproduce
- Any error output

## License

By contributing you agree your work is licensed under the MIT License.
