{
    lib,
    pkgs,
    ...
}:
let
    isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in
{
    programs.kitty = {
        enable = true;
        font = {
            name = "Maple Mono NF CN";
            size = if isDarwin then 14 else 12;
        };
        settings = {
            confirm_os_window_close = 0;
            cursor_trail = 0;
            pixel_scroll = true;
            scrollback_lines = 1000;
            wheel_scroll_min_lines = 1;
            enable_audio_bell = false;
            window_padding_width = 4;
            tab_bar_edge = "bottom";
            tab_bar_style = "powerline";
            tab_powerline_style = "slanted";
            tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
            enabled_layouts = "tall,stack";
        }
        // lib.optionalAttrs isDarwin {
            cursor_shape = "block";
        }
        // lib.optionalAttrs (!isDarwin) {
            background_opacity = "0.93";
            background_blur = 1;
        };
        keybindings = {
            "ctrl+shift+enter" = "new_window_with_cwd";
            "ctrl+shift+u" = "detach_window new-tab";
        }
        // lib.optionalAttrs (!isDarwin) {
            "ctrl+c" = "copy_or_interrupt";
            "ctrl+v" = "paste_from_clipboard";
        };
        extraConfig = "include themes/noctalia.conf";
    };
}
