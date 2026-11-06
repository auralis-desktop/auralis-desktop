-- Auralis Hyprland Configuration
-- Main entry point -- loads all modules
-- ~/.config/hypr/hyprland.lua

local config_dir = vim and vim.fn.expand("~/.config/hypr") or (os.getenv("HOME") .. "/.config/hypr")

-- Helper: resolve module path relative to this file's directory
local function module(name)
    return dofile(config_dir .. "/config/" .. name .. ".lua")
end

-- Load all modules in order
module("environment")
module("monitors")
module("input")
module("settings")
module("decorations")
module("animations")
module("keybinds")
module("windowrules")
module("workspaces")
module("startup")
