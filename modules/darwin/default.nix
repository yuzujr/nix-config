{ ... }:
{
    imports = [
        ./core
        ./home-manager
        ./homebrew
        ./secrets
    ];

    system.stateVersion = 4;

    # System settings (Dock, etc.) can be added here
}
