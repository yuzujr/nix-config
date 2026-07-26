{
    inputs,
    vars,
    ...
}:
{
    imports = [
        inputs.home-manager.darwinModules.home-manager
        ../shared/home-manager.nix
    ];

    home-manager.users.${vars.username}.imports = [ ../home/darwin ];
}
