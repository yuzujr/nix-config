{
    config,
    lib,
    vars,
    osConfig ? { },
    ...
}:
let
    mkSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
    imports = [
        ./direnv.nix
        ./dotfiles.nix
        ./emacs.nix
        ./git.nix
        ./ssh.nix
        ./tmux.nix
    ];

    _module.args = {
        inherit mkSymlink;

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

        secretPath = name: osConfig.sops.secrets.${name}.path or "/run/secrets/${name}";
    };
}
