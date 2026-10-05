{ vars, secretsLib, ... }:
{
    sops.secrets."apps/gold-price-history" =
        secretsLib.mkSecret "apps.yaml" "gold-price-history"
            secretsLib.userSecret;

    home-manager.users.${vars.username}.imports = [ ../../home/linux/services/gold-price.nix ];
}
