{
    config,
    lib,
    pkgs,
    ...
}:
let
    cfg = config.services.sunshine;
in
{
    options.services.sunshine = {
        enable = lib.mkEnableOption "Sunshine game stream host";
        autoStart = lib.mkEnableOption "starting Sunshine automatically with the graphical session";
    };

    config = lib.mkIf cfg.enable {
        home.packages = [ pkgs.sunshine ];

        systemd.user.services.sunshine = {
            Unit = {
                Description = "Self-hosted game stream host for Moonlight";
                StartLimitIntervalSec = 500;
                StartLimitBurst = 5;
                PartOf = [ "graphical-session.target" ];
                After = [ "graphical-session.target" ];
                BindsTo = [ "graphical-session.target" ];
            };

            Service = {
                # Only allow Sunshine to start under the normal Niri profile.
                ExecCondition = "${pkgs.bash}/bin/bash -lc 'target=$(${pkgs.coreutils}/bin/readlink \"$HOME/.config/niri/profiles/current-config.kdl\" 2>/dev/null || true); [[ \"$target\" == normal/config.kdl ]]'";
                ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
                ExecStart = "${pkgs.sunshine}/bin/sunshine";
                Restart = "on-failure";
                RestartSec = "5s";
            };
        }
        // lib.optionalAttrs cfg.autoStart {
            Install.WantedBy = [ "graphical-session.target" ];
        };
    };
}
