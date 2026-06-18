{ ... }:
{
    services.tailscale = {
        enable = true;
        openFirewall = true;

        # Keep Tailscale as a private-device overlay only. Do not enable
        # subnet-router or exit-node routing here; mihomo already manages a TUN.
        useRoutingFeatures = "none";
    };

    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [
        3000 # Open WebUI
        8000 # SillyTavern
    ];
}
