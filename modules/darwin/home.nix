{
    inputs,
    ...
}:
{
    imports = [
        inputs.home-manager.darwinModules.home-manager
        ../shared/home-manager.nix
    ];
}
