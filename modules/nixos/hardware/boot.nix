{ config, pkgs, ... }:
{
    boot.loader = {
        timeout = 5;
        systemd-boot = {
            enable = true;
            configurationLimit = 10;
        };
        efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/efi";
        };
    };

    boot.kernelPackages = pkgs.linuxPackages_6_18;
    boot.extraModulePackages = with config.boot.kernelPackages; [
        yt6801
    ];

    zramSwap.enable = true;
}
