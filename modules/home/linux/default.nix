{ inputs, pkgs, ... }:
{
    imports = [
        ../common
        ./dotfiles.nix
        ./input.nix
        ./mpv.nix
        ./niri.nix
        ./noctalia.nix
        ./packages.nix
        ./services
        ./xdg.nix
    ];

    _module.args.localPackages = import ../../../packages { inherit inputs pkgs; };
}
