# Cross-platform policy shared by NixOS and nix-darwin.
{
    programs.fish.enable = true;

    nixpkgs.config.allowUnfree = true;
}
