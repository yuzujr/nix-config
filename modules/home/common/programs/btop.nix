{ pkgs, ... }:
let
    isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in
{
    programs.btop = {
        enable = true;
        settings = {
            color_theme = if isDarwin then "TTY" else "noctalia";
            theme_background = false;
            shown_boxes = "net mem proc cpu";
            proc_sorting = "cpu direct";
            show_cpu_watts = true;
            update_ms = 2000;
            save_config_on_exit = false;
        };
    };
}
