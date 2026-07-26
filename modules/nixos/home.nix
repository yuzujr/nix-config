{
    inputs,
    lib,
    vars,
    ...
}:
{
    imports = [
        inputs.home-manager.nixosModules.home-manager
        ../shared/home-manager.nix
    ];

    home-manager.users.${vars.username}.imports = [ ../home/linux ];

    # Disable Home Manager auto-activation at boot; run it manually when needed.
    systemd.services."home-manager-${vars.username}".wantedBy = lib.mkForce [ ];
}
