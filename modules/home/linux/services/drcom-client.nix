{
    config,
    ...
}:
{
    systemd.user.services.drcom = {
        Unit = {
            Description = "DRCOM client";
            After = [ "network-online.target" ];
            Wants = [ "network-online.target" ];
        };
        Service = {
            ExecStart = "${config.home.profileDirectory}/bin/drcom_client -c ${config.xdg.configHome}/drcom-client-cpp/drcom-jlu.conf";
        };
        # Deliberately not enabled at boot: start drcom manually when on the
        # campus network.
        Install = { };
    };
}
