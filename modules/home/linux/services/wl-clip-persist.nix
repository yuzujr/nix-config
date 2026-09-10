{
    services.wl-clip-persist = {
        enable = true;
        systemdTargets = "niri.service";
    };

    systemd.user.services.wl-clip-persist = {
        Unit.BindsTo = [ "niri.service" ];
        Service.RestartSec = 1;
    };
}
