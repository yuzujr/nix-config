{
    config,
    dot,
    lib,
    hasSecret,
    mkSymlink,
    secretPath,
    localPackages,
    ...
}:
let
    cfg = config.services.gold-price;
in
{
    options.services.gold-price.enable = lib.mkEnableOption "Gold price watcher and daily history services";

    config = lib.mkIf cfg.enable {
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
                    Unit.Description = "Gold price watcher (USD/oz)";
                    Service = {
                        Type = "simple";
                        ExecStart = "${localPackages.gold-price}/bin/gold-price-watch --loop";
                        Restart = "always";
                        RestartSec = 10;
                    };
                    Install.WantedBy = [ "default.target" ];
                };

                gold-price-history-daily = {
                    Unit.Description = "Fetch and store daily gold price history (USD/oz)";
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
    };
}
