{
    dot,
    lib,
    hasSecret,
    mkSymlink,
    secretPath,
    localPackages,
    ...
}:
{
    home.packages = [ localPackages.gold-price ];

    xdg.configFile = {
        "gold-price/gold-price-watch.conf" = dot "gold-price/gold-price-watch.conf";
    }
    // lib.optionalAttrs (hasSecret "apps/gold-price-history") {
        "gold-price/gold-price-history.conf".source = mkSymlink (secretPath "apps/gold-price-history");
    };

    systemd.user = {
        services = {
            gold-price-watch = {
                Unit = {
                    Description = "Gold price watcher (USD/oz)";
                    After = [ "network-online.target" ];
                    Wants = [ "network-online.target" ];
                };
                Service = {
                    Type = "simple";
                    ExecStart = "${localPackages.gold-price}/bin/gold-price-watch --loop";
                    Restart = "always";
                    RestartSec = 10;
                };
                Install.WantedBy = [ "default.target" ];
            };

            gold-price-history-daily = {
                Unit = {
                    Description = "Fetch and store daily gold price history (USD/oz)";
                    After = [ "network-online.target" ];
                    Wants = [ "network-online.target" ];
                };
                Service = {
                    Type = "oneshot";
                    ExecStart = "${localPackages.gold-price}/bin/gold-price-history-daily";
                };
            };
        };

        timers.gold-price-history-daily = {
            Unit.Description = "Run gold-price-history-daily once per day";
            Timer = {
                OnCalendar = "*-*-* 00:10:00";
                RandomizedDelaySec = "15m";
                Persistent = true;
                Unit = "gold-price-history-daily.service";
            };
            Install.WantedBy = [ "timers.target" ];
        };
    };
}
