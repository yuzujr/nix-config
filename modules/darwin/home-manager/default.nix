{
    home-manager,
    rosePineDoomEmacsSrc,
    vars,
    ...
}:
{
    imports = [
        home-manager.darwinModules.home-manager
    ];

    home-manager = import ../../../lib/home-manager.nix {
        inherit vars;
        homeStateVersion = "24.11";
        extraSpecialArgs = {
            inherit rosePineDoomEmacsSrc;
        };
    };
}
