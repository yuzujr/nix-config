{
    config,
    pkgs,
    lib,
    vars,
    ...
}:
{
    imports = [
        ./homebrew.nix
        ./secrets.nix
    ];

    system.stateVersion = 4;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Setup the default shell for the user
    programs.fish.enable = true;

    # Do not manage nix daemon as we are using Determinate Systems installer
    nix.enable = false;

    # System settings (Dock, etc.) can be added here
}
