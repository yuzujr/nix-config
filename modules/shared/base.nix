# Cross-platform policy shared by NixOS and nix-darwin.
{
    programs.fish.enable = true;

    # System and user packages include unfree apps (google-chrome, qq, wechat,
    # vscode, ...), so allow them globally. Dev shells are stricter and scope
    # unfree to android-studio only (see devshells/default.nix).
    nixpkgs.config.allowUnfree = true;
}
