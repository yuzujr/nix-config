{ ... }:
{
    # Do not manage nix daemon as we are using Determinate Systems installer.
    nix.enable = false;

    nixpkgs.config.allowUnfree = true;
}
