{ ... }:
{
    imports = [
        ./networkmanager.nix
        ./sshd.nix
        ./mihomo.nix
        ./tailscale.nix
    ];
}
