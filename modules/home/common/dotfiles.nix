# Cross-platform config files, symlinked back into the repo so edits apply
# without a rebuild. Platform-specific files live in ../linux/dotfiles.nix
# and ../darwin/dotfiles.nix.
{
    config,
    lib,
    vars,
    osConfig ? { },
    ...
}:
let
    mkSymlink = config.lib.file.mkOutOfStoreSymlink;
    dot = path: {
        source = mkSymlink "${vars.repoRoot}/dotfiles/${path}";
    };
    hasSecret =
        name:
        lib.hasAttrByPath [
            "sops"
            "secrets"
            name
        ] osConfig;
in
{
    home.file.".local/bin" = dot "local/bin";

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
        }
        // lib.optionalAttrs (hasSecret "network/drcom-jlu") {
            "drcom-client-cpp/drcom-jlu.conf".source = mkSymlink osConfig.sops.secrets."network/drcom-jlu".path;
        };
}
