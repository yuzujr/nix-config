# Cross-platform policy shared by NixOS and nix-darwin.
{ lib, ... }:
{
    programs.fish.enable = lib.mkDefault true;

    # System and user packages include unfree apps (google-chrome, qq, wechat,
    # ...), so allow them globally. Dev shells are stricter and scope unfree to
    # android-studio only (see devshells/default.nix).
    nixpkgs.config.allowUnfree = lib.mkDefault true;
}
