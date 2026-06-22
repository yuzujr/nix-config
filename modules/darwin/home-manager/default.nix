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

    home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
            inherit vars rosePineDoomEmacsSrc;
        };
        users.${vars.username} = {
            imports = [
                ../../home
                ../../home/darwin
            ];
            home.stateVersion = "26.05";
            home.enableNixpkgsReleaseCheck = false;
        };
    };
}
