{ lib, pkgs, ... }:
{
    # All service modules are imported unconditionally so their options are
    # always declared. Each module is expected to guard its own config with
    # lib.mkIf pkgs.stdenv.isLinux internally.
    imports = [
        ./drcom-client.nix
        ./gold-price-history-daily.nix
        ./gold-price-watch.nix
        ./sunshine.nix
        ./wl-clip-persist.nix
    ];

    # mpris-proxy requires D-Bus (Linux only)
    services.mpris-proxy.enable = lib.mkIf pkgs.stdenv.isLinux true;
}
