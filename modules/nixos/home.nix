{
    inputs,
    vars,
    ...
}:
{
    imports = [
        inputs.home-manager.nixosModules.home-manager
        ../shared/home-manager.nix
    ];

    home-manager.users.${vars.username}.imports = [ ../home/linux ];

}
