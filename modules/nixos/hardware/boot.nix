{ pkgs, ... }:
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

    boot.kernelPackages = pkgs.linuxPackages_latest;

    zramSwap.enable = true;
}
