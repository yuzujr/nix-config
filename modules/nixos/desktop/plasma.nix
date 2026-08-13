{ pkgs, ... }:
{
    services.desktopManager.plasma6.enable = true;

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
        plasma-browser-integration
        elisa
        gwenview
        okular
        khelpcenter
        krdp
    ];

    # Keep Plasma installed, but disable KDE's crash handler entirely.
    systemd = {
        services."drkonqi-coredump-processor@".enable = false;
        user = {
            sockets."drkonqi-coredump-launcher".enable = false;
            services = {
                "drkonqi-coredump-launcher@".enable = false;
                "drkonqi-coredump-pickup".enable = false;
                "drkonqi-sentry-postman".enable = false;
            };
            timers = {
                "drkonqi-coredump-cleanup".enable = false;
                "drkonqi-sentry-postman".enable = false;
            };
            paths."drkonqi-sentry-postman".enable = false;
        };
    };
}
