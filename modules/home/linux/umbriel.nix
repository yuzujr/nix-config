{ inputs, osConfig, ... }:
{
    imports = [ inputs.umbriel.homeModules.default ];

    programs.umbriel = {
        enable = true;
        package = osConfig.programs.umbriel.package;
        settings = {
            # Keep upstream bindings and rules in sync with the pinned package.
            include.files = [ "${osConfig.programs.umbriel.package}/share/umbriel/config.toml" ];
            include.optional.files = [ "~/.config/umbriel/noctalia.toml" ];
            general.autostart = [ "noctalia" ];
            layout.mode = "scrolling";
            environment = {
                QT_QPA_PLATFORM = "wayland";
                QT_QPA_PLATFORMTHEME = "qt6ct";
            };
            input.keyboard.options = "ctrl:nocaps";
            events.lid_close = "noctalia msg screen-lock";
            keybinds = {
                "Mod+Alt+L" = "spawn:noctalia msg screen-lock";
                "Mod+Ctrl+T" = "workspace-set-layout:toggle";
                "XF86AudioLowerVolume" = "spawn:noctalia msg volume-down";
                "XF86AudioRaiseVolume" = "spawn:noctalia msg volume-up";
                "XF86AudioMute" = "spawn:noctalia msg volume-mute";
                "XF86AudioMicMute" = "spawn:noctalia msg mic-mute";
                "XF86MonBrightnessUp" = "spawn:noctalia msg brightness-up";
                "XF86MonBrightnessDown" = "spawn:noctalia msg brightness-down";
            };
        };
    };
}
