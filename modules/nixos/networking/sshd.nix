{
    services.openssh = {
        enable = true;
        openFirewall = false;
    };

    # Restrict SSH access to the Tailscale interface while keeping password auth.
    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22 ];
}
