{ vars, ... }:
{
    imports = [
        ./dotfiles
        ./services
        ./user
    ];

    home = {
        inherit (vars) username;
        # stateVersion is intentionally set per-host, not here.
        # NixOS host: modules/nixos/home-manager/default.nix
        # macOS host:  hosts/macbook/default.nix
    };
}
