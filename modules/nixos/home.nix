{
    inputs,
    ...
}:
{
    imports = [
        inputs.home-manager.nixosModules.home-manager
        ../shared/home-manager.nix
    ];
}
