{ vars, ... }:
{
    imports = [
        ./hardware-configuration.nix
        ./hardware.nix
        ../../modules/nixos
        ../../modules/nixos/desktop
        ../../modules/nixos/hardware
        ../../modules/nixos/networking/drcom-client.nix
        ../../modules/nixos/networking/mihomo.nix
        ../../modules/nixos/networking/networkmanager.nix
        ../../modules/nixos/networking/sshd.nix
        ../../modules/nixos/networking/tailscale.nix
        ../../modules/nixos/services/gold-price.nix
        ../../modules/nixos/services/nixloom.nix
    ];

    networking.hostName = "laptop-nixos";
    services.power-profiles-daemon.enable = true;
    home-manager.users.${vars.username} = {
        imports = [
            ../../modules/home/linux
            ../../modules/home/linux/services/sunshine.nix
        ];

        services.nixloom.acceleration = "cuda";
    };
    virtualisation.vmware.host.enable = false;
    system.stateVersion = "25.11";
}
