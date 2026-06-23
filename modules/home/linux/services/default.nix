{ ... }:
{
    # All service modules are imported unconditionally so their options are
    # always declared. Platform guarding is handled at the import level
    # (modules/home/default.nix checks vars.isDarwin).
    imports = [
        ./drcom-client.nix
        ./gold-price-history-daily.nix
        ./gold-price-watch.nix
        ./sunshine.nix
        ./wl-clip-persist.nix
    ];

    services.mpris-proxy.enable = true;
}
