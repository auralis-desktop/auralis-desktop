-- Auralis: Animations
-- Smooth Material 3-inspired motion

Hyprland.animations({
    enabled = true,

    -- Bezier curves
    bezier = {
        { "md3_standard",   0.2,  0.0,  0.0,  1.0 },
        { "md3_decel",      0.05, 0.7,  0.1,  1.0 },
        { "md3_accel",      0.3,  0.0,  0.8,  0.15 },
        { "linear",         0.0,  0.0,  1.0,  1.0 },
        { "easeInOut",      0.4,  0.0,  0.2,  1.0 },
        { "easeOutBack",    0.34, 1.56, 0.64, 1.0 },
        { "overshot",       0.05, 0.9,  0.1,  1.1 },
    },

    -- Animations
    animation = {
        { "windows",        true, 3, "md3_decel",    "popin 60%" },
        { "windowsIn",      true, 3, "md3_decel",    "popin 60%" },
        { "windowsOut",     true, 2, "md3_accel",    "popin 60%" },
        { "windowsMove",    true, 3, "md3_standard"  },
        { "border",         true, 5, "linear"        },
        { "borderangle",    true, 8, "linear",        "loop" },
        { "fade",           true, 3, "md3_decel"     },
        { "fadeIn",         true, 3, "md3_decel"     },
        { "fadeOut",        true, 2, "md3_accel"     },
        { "fadeDim",        true, 3, "md3_standard"  },
        { "workspaces",     true, 4, "md3_decel",    "slidefade 15%" },
        { "specialWorkspace", true, 4, "md3_decel",  "slidefadevert 15%" },
    },
})
