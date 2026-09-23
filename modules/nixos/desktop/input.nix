{ pkgs, ... }:
{
    i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5.waylandFrontend = true;
        fcitx5.addons = with pkgs; [
            (fcitx5-mellow-themes.overrideAttrs (_: {
                version = "0-unstable-2026-09-10";
                src = fetchFromGitHub {
                    owner = "sanweiya";
                    repo = "fcitx5-mellow-themes";
                    rev = "2c93b0ea3418a55c03f526d963c84a7ccde2c1e9";
                    hash = "sha256-y7Q7BgObG99l0+8UVn24TibmUK3Xdq+/1N/G4o9eYAY=";
                };
            }))
            (fcitx5-rime.override {
                rimeDataPkgs = [ pkgs.rime-ice ];
            })
            qt6Packages.fcitx5-configtool
        ];
    };
}
