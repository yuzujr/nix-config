{
    pkgs,
    lib,
    vars,
    home-manager,
    rosePineDoomEmacsSrc,
    ...
}:
{
    imports = [
        home-manager.darwinModules.home-manager
        ../../modules/darwin
    ];

    # Primary user is required by nix-darwin for some features like homebrew
    system.primaryUser = vars.username;

    # Users
    users.users."${vars.username}" = {
        name = vars.username;
        home = "/Users/${vars.username}";
    };

    home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
            inherit vars rosePineDoomEmacsSrc;
        };
        users."${vars.username}" = {
            imports = [
                ../../modules/home
            ];
            # macOS stateVersion — set at initial deploy, do not change
            home.stateVersion = "24.11";
            home.enableNixpkgsReleaseCheck = false;
        };
    };
}
