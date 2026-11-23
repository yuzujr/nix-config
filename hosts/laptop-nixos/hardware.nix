{ config, ... }:
{
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
        open = true;
        package = config.boot.kernelPackages.nvidiaPackages.latest;
        modesetting.enable = true;
        powerManagement.enable = true;
        dynamicBoost.enable = true;
        nvidiaSettings = false;
    };

    # Allow DHCP, DNS, and forwarding across external TUN interfaces (e.g. mihomo) when sharing internet via Wi-Fi hotspot.
    boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
    networking.firewall.interfaces.wlp3s0 = {
        allowedUDPPorts = [
            53
            67
        ];
        allowedTCPPorts = [ 53 ];
    };
}
