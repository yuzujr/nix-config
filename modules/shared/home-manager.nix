{
    inputs,
    vars,
    ...
}:
{
    imports = [
        (
            if vars.isDarwin then
                inputs.home-manager.darwinModules.home-manager
            else
                inputs.home-manager.nixosModules.home-manager
        )
    ];

    home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "home-manager.backup";
        extraSpecialArgs = {
            inherit inputs vars;
        };
        users.${vars.username} = {
            imports = [
                ../home
            ];
            home.stateVersion = "26.05";
            home.enableNixpkgsReleaseCheck = false;
        };
    };
}
