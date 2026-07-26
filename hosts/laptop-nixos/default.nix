{
    imports = [
        ./hardware-configuration.nix
        ./hardware.nix
        ../../modules/nixos
    ];

    networking.hostName = "laptop-nixos";

    system.stateVersion = "25.11";
}
