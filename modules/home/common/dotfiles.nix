{
    lib,
    hasSecret,
    mkSymlink,
    osConfig ? { },
    ...
}:
{
    xdg.configFile = lib.optionalAttrs (hasSecret "nix/user-conf") {
        "nix/nix.conf".source = mkSymlink osConfig.sops.secrets."nix/user-conf".path;
    };
}
