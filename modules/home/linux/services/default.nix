# These modules only define systemd user units; the whole subtree is
# linux-only via the platform split in modules/nixos/home.nix.
{
    imports = [
        ./drcom-client.nix
        ./gold-price-history-daily.nix
        ./gold-price-watch.nix
        ./mpris-proxy.nix
        ./nixloom.nix
        ./sunshine.nix
        ./wl-clip-persist.nix
    ];
}
