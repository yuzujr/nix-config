{ vars, ... }:
{
    imports = [
        ./common
    ];

    home = {
        inherit (vars) username;
        # stateVersion is intentionally set per-host, not here.
        # NixOS host: modules/nixos/home-manager/default.nix
        # macOS host:  modules/darwin/home-manager/default.nix
    };
}
