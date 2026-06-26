{ config, pkgs, ... }:
{
    # Replace the built-in activation daemon (which references a specific store path
    # and breaks after GC or on boot race) with one that uses the profile path directly.
    # Disable the old one so they don't both run the same activate script.
    launchd.daemons = {
        activate-system.serviceConfig.Disabled = true;

        current-system-link.serviceConfig = {
            Label = "org.nixos.current-system-link";
            ProgramArguments = [
                "/bin/sh"
                "-c"
                "/bin/wait4path /nix/var/nix/profiles/system && exec /nix/var/nix/profiles/system/activate"
            ];
            RunAtLoad = true;
            KeepAlive = {
                SuccessfulExit = false;
            };
            StandardErrorPath = "/var/log/org.nixos.current-system-link.err.log";
            StandardOutPath = "/var/log/org.nixos.current-system-link.out.log";
        };
    };
}
