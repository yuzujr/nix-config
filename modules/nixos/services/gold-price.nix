{
    config,
    lib,
    vars,
    secretsLib,
    ...
}:
let
    cfg = config.services.gold-price;
in
{
    options.services.gold-price.enable = lib.mkEnableOption "Gold price watcher and daily history services";

    config = {
        sops.secrets = lib.mkIf cfg.enable {
            "apps/gold-price-history" =
                secretsLib.mkSecret "apps.yaml" "gold-price-history"
                    secretsLib.userSecret;
        };

        home-manager.users.${vars.username} = {
            imports = [ ../../home/linux/services/gold-price.nix ];
            services.gold-price.enable = lib.mkDefault cfg.enable;
        };
    };
}
