# Home Manager settings shared by both platforms. The platform module import
# and the per-platform entrypoint are wired in modules/{nixos,darwin}/home.nix.
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
