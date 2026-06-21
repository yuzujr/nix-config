{ lib, pkgs, ... }:
{
    imports = [
        ./direnv.nix
        ./emacs.nix
        ./git.nix
        ./mpv.nix
        ../packages
        ./ssh.nix
        ./xdg.nix
    ];

    # fontconfig is Linux-only; macOS uses its own font system
    fonts.fontconfig.enable = lib.mkIf pkgs.stdenv.isLinux false;
}
