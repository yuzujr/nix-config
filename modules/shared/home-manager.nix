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
            home.stateVersion = "26.05";
            home.enableNixpkgsReleaseCheck = false;
        };
    };
}
