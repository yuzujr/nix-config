{ pkgs, ... }:
{
    home.packages = with pkgs; [ nh ];

    imports = [
        ./git.nix
    ];
}
