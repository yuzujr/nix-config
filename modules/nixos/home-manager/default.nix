{
    ani2xcursorPkg,
    coomerPkg,
    drcomClientPkg,
    home-manager,
    noctaliaPkg,
    rosePineDoomEmacsSrc,
    vars,
    ...
}:
{
    imports = [
        home-manager.nixosModules.home-manager
    ];

    home-manager = (import ../../../lib/home-manager.nix {
        inherit vars;
        homeStateVersion = "26.05";
        extraSpecialArgs = {
            inherit
                ani2xcursorPkg
                coomerPkg
                drcomClientPkg
                noctaliaPkg
                rosePineDoomEmacsSrc
                ;
        };
    }) // {
        backupFileExtension = "home-manager.backup";
    };
}
