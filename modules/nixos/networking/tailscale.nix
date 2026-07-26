{
    services.tailscale = {
        enable = true;
        openFirewall = true;

        # Keep Tailscale as a private-device overlay only. Do not enable
        # subnet-router or exit-node routing here; mihomo already manages a TUN.
        useRoutingFeatures = "none";
    };

    systemd.services.tailscaled = {
        after = [ "mihomo.service" ];
        wants = [ "mihomo.service" ];
        environment = {
            HTTP_PROXY = "http://127.0.0.1:8907";
            HTTPS_PROXY = "http://127.0.0.1:8907";
        };
    };

    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [
        3000 # Open WebUI
        8000 # SillyTavern
    ];
}
