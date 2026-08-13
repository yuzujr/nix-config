# Cross-platform config files, symlinked back into the repo so edits apply
# without a rebuild. Platform-specific files live in ../linux/dotfiles.nix
# and ../darwin/dotfiles.nix.
{
    lib,
    dot,
    hasSecret,
    mkSymlink,
    osConfig ? { },
    ...
}:
{
    xdg.configFile =
        lib.genAttrs [
            "fish"
            "nvim"
            "emacs"
            "starship.toml"
            "fastfetch"
            "btop"
        ] dot
        // lib.optionalAttrs (hasSecret "nix/user-conf") {
            "nix/nix.conf".source = mkSymlink osConfig.sops.secrets."nix/user-conf".path;
        };
}
