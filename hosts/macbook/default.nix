{
    vars,
    ...
}:
{
    imports = [
        ../../modules/darwin
    ];

    # Primary user is required by nix-darwin for some features like homebrew
    system.primaryUser = vars.username;

    # Users
    users.users."${vars.username}" = {
        name = vars.username;
        home = vars.homeDirectory;
    };
}
