{
    config,
    lib,
    pkgs,
    secretsLib,
    ...
}:
{
    sops.secrets."network/mihomo" = secretsLib.mkSecret "network.yaml" "mihomo" (
        secretsLib.rootSecret // { restartUnits = [ "mihomo.service" ]; }
    );

    services.mihomo = {
        enable = true;
        tunMode = true;
        webui = pkgs.metacubexd;
        configFile = config.sops.secrets."network/mihomo".path;
    };
    # Mihomo's TUN mode can use asymmetric routing that conflicts with
    # NixOS's default strict reverse-path filtering.
    networking.firewall.checkReversePath = lib.mkDefault "loose";
}
