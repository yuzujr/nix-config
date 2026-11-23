{ dot, pkgs, ... }:
let
    isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
    kittyThemes = "${pkgs.kitty-themes}/share/kitty-themes/themes";
in
{
    home.packages = [ pkgs.kitty ];

    xdg.configFile = {
        "kitty/kitty.conf" = dot "kitty/kitty.conf";
        "kitty/platform.conf" = dot (if isDarwin then "kitty/darwin.conf" else "kitty/linux.conf");
        "kitty/dark-theme.auto.conf".source = "${kittyThemes}/rose-pine.conf";
        "kitty/light-theme.auto.conf".source = "${kittyThemes}/rose-pine-dawn.conf";
        "kitty/no-preference-theme.auto.conf".source = "${kittyThemes}/rose-pine.conf";
    };
}
