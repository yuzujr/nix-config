{ pkgs, ... }:
{
    programs.mpv = {
        enable = true;

        scripts = with pkgs.mpvScripts; [
            autoload
            modernz
            quality-menu
            sponsorblock
            thumbfast
            mpris
        ];

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
