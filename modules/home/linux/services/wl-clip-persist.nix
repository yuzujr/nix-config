{
    pkgs,
    ...
}:
{
    services.wl-clip-persist = {
        enable = true;
        systemdTargets = "niri.service";
    };

    systemd.user.services.wl-clip-persist = {
        Unit.BindsTo = [ "niri.service" ];
        Service = {
            # Normal mode runs Noctalia, which already persists clipboard selections.
            ExecCondition = "${pkgs.bash}/bin/bash -lc 'target=$(${pkgs.coreutils}/bin/readlink \"$HOME/.config/niri/profiles/current-config.kdl\" 2>/dev/null || true); [[ \"$target\" == travel/config.kdl ]]'";
            RestartSec = 1;
        };
    };
}
