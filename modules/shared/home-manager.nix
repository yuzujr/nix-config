# Home Manager settings shared by both platforms. Platform integration lives
# in modules/{nixos,darwin}/home.nix; hosts select their user modules.
{
    inputs,
    vars,
    ...
}:
{
    home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "home-manager.backup";
        extraSpecialArgs = {
            inherit inputs vars;
        };
        users.${vars.username} = {
            # Preserve the defaults from when this Home Manager config was created.
            home.stateVersion = "26.05";
        };
    };
}
