{ lib, dot, ... }:
{
    home.file.".local/bin" = dot "local/bin";

    xdg.configFile = lib.genAttrs [
        "chrome-flags.conf"
        "feh"
        "nwg-look"
        "qt6ct"
        "termway"
        "zathura"
    ] dot;
}
