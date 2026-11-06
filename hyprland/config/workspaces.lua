-- Auralis: Workspace configuration

-- Named workspaces 1-10
local workspace_names = {
    [1]  = "I",
    [2]  = "II",
    [3]  = "III",
    [4]  = "IV",
    [5]  = "V",
    [6]  = "VI",
    [7]  = "VII",
    [8]  = "VIII",
    [9]  = "IX",
    [10] = "X",
}

for id, name in pairs(workspace_names) do
    Hyprland.workspace(tostring(id), { name = name })
end

-- Scratchpad
Hyprland.workspace("special:scratchpad", {
    on_created_empty = "kitty",
})

-- Persistent workspaces on primary monitor
-- Adjust "DP-1" to your monitor name
-- Hyprland.workspace("1", { monitor = "DP-1", persistent = true })
