{ config, ... }:
{
    hardware.graphics = {
        enable = true;
        enable32Bit = true;
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
        open = true;
        package = config.boot.kernelPackages.nvidiaPackages.latest;
        modesetting.enable = true;
        powerManagement.enable = true;
        dynamicBoost.enable = true;
        nvidiaSettings = false;
    };
}
