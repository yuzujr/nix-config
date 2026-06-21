{ pkgs, lib, ... }:
{
    programs.mpv = {
        enable = true;

        scripts = with pkgs.mpvScripts;
            [
                autoload
                modernz
                quality-menu
                sponsorblock
                thumbfast
            ]
            # mpris requires D-Bus (Linux only)
            ++ lib.optional pkgs.stdenv.isLinux mpris;

        config = {
            osc = false;
            osd-bar = false;
            ytdl-format = "bestvideo+bestaudio/best";
        };

        scriptOpts = {
            modernz = {
                icon_theme = "material";
            };
        };
    };
}
