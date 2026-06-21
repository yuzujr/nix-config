{ vars, homeStateVersion, extraSpecialArgs ? { } }:
{
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = extraSpecialArgs // {
        inherit vars;
    };
    users.${vars.username} = {
        imports = [
            ../modules/home
        ];
        home.stateVersion = homeStateVersion;
        home.enableNixpkgsReleaseCheck = false;
    };
}
