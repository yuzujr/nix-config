{ ... }:
{
    imports = [
        ../shared/home-manager.nix
        ./homebrew
        ./secrets
    ];

    system.stateVersion = 4;

    # Do not manage nix daemon as we are using Determinate Systems installer.
    nix.enable = false;

    nixpkgs.config.allowUnfree = true;

    programs.fish.enable = true;
}
