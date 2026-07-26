# Hand-written hardware specifics for this laptop (NVIDIA dGPU, Motorcomm
# yt6801 ethernet). The generic hardware baseline lives in modules/nixos.
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

    boot.extraModprobeConfig = ''
        options nvidia_drm fbdev=0
    '';

    boot.extraModulePackages = with config.boot.kernelPackages; [
        yt6801
    ];

    # Pin KWin to this laptop's iGPU + dGPU DRM devices.
    environment.sessionVariables.KWIN_DRM_DEVICES = "/dev/dri/by-path/pci-0000\\:01\\:00.0-card:/dev/dri/by-path/pci-0000\\:06\\:00.0-card";
}
