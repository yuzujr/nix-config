{
    services.wl-clip-persist = {
        enable = true;
        systemdTargets = "niri.service";
    };

    # Keep the stricter lifecycle of the previous hand-rolled unit: die with
    # niri on an abrupt crash (PartOf only covers explicit stop/restart) and
    # back off a full second between restarts.
    systemd.user.services.wl-clip-persist = {
        Unit.BindsTo = [ "niri.service" ];
        Service.RestartSec = 1;
    };
}
