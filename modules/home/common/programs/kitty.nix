{ dot, pkgs, ... }:
let
    isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in
{
    home.packages = [ pkgs.kitty ];

    xdg.configFile = {
        "kitty/kitty.conf" = dot "kitty/kitty.conf";
        "kitty/platform.conf" = dot (if isDarwin then "kitty/darwin.conf" else "kitty/linux.conf");
    };
}
