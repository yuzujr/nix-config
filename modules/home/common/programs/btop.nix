{ dot, pkgs, ... }:
{
    home.packages = [ pkgs.btop ];
    xdg.configFile."btop/btop.conf" = dot "btop/btop.conf";
}
