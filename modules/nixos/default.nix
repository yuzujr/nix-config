{ ... }:
{
    imports = [
        ../shared/home-manager.nix
        ./core
        ./desktop
        ./hardware
        ./networking
        ./secrets
        ./virtualization
    ];
}
