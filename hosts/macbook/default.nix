{
    config,
    pkgs,
    lib,
    vars,
    home-manager,
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
        extraSpecialArgs = { inherit vars; };
        users."${vars.username}" = {
            imports = [
                ../../modules/home/dotfiles/default.nix
            ];
            home.stateVersion = "24.11";
            home.enableNixpkgsReleaseCheck = false;
        };
    };
}
